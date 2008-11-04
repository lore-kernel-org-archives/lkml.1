Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYKDH4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYKDH4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 02:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYKDH4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 02:56:17 -0500
Received: from smtp-out.google.com ([216.239.45.13]:19724 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbYKDH4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 02:56:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=epEo3Vht0Pe7X+JyIFGQQaJHtiXuE6APVCvkUWsqwjrVm9j6UfDQu4LgNiTMHMWnQ
	BI4giNmPmPTc+JBvD3xAQ==
MIME-Version: 1.0
In-Reply-To: <490FFB56.7030300@cn.fujitsu.com>
References: <20080811235323.872291138@us.ibm.com>
	 <20080811235325.121356317@us.ibm.com>
	 <6599ad830811032143h51eae533k5b0c17e65a7fa675@mail.gmail.com>
	 <490FE7B5.8020400@cn.fujitsu.com>
	 <6599ad830811032240n640f3fao48f1a9f05892b797@mail.gmail.com>
	 <490FFB56.7030300@cn.fujitsu.com>
Date: Mon, 3 Nov 2008 23:56:13 -0800
Message-ID: <6599ad830811032356g6827a97dq41dec492fed8de15@mail.gmail.com>
Subject: Re: [RFC][PATCH] freezer_cg: disable writing freezer.state of root 
	cgroup
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2008 at 11:35 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> With this change, the root cgroup is unfreezable, and writing to
> its freezer.state returns -EIO.

EINVAL might be more consistent with other systems like cpusets.

Or maybe just skip populating the file entirely for the root cgroup?
It's not useful if it can't be written and always returns the same
value.

Paul
