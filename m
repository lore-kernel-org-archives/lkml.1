Return-Path: <linux-kernel-owner+w=401wt.eu-S1946083AbXDEIK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946083AbXDEIK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946085AbXDEIK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:10:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25715 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946083AbXDEIKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:10:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Dfiwu0aVjqv3SGZDwUuWwqL82mBQgLxmz2ApAUHBJr0QnAEydBcHdOf43w5x/f8r0
	TW5GNQ9Rog2e/gsiApTzQ==
Message-ID: <6599ad830704050110w65c2312br3c8d070da5d6dfa5@mail.gmail.com>
Date: Thu, 5 Apr 2007 01:10:21 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
Cc: "Paul Jackson" <pj@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Balbir Singh" <balbir@in.ibm.com>
In-Reply-To: <20070405081424.GA20356@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070325164746.GI11794@in.ibm.com>
	 <20070325125025.b6e8f0d4.pj@sgi.com>
	 <20070326115506.GL11794@in.ibm.com>
	 <6599ad830704042255t5c126a0cj86d644cb8174e177@mail.gmail.com>
	 <20070405070033.GB3435@in.ibm.com>
	 <6599ad830704050001n50d9fa2bw4167c1fa16aa618f@mail.gmail.com>
	 <20070405081424.GA20356@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
>
> Hmm yes ..I am surprised we arent doing a synhronize_rcu in
> cpuset_rmdir() before dropping the dentry. Did you want to send a patch
> for that?

Currently cpuset_exit() isn't in a rcu section so it wouldn't help.

But this ceases to be a problem if we don't leave the refcount
dropping in cpuset_exit() where it is currently - it doesn't drop the
refcount until it's holding manage_mutex, at which point it's safe to
hold a cpuset reference with a refcount of 0.

Paul
