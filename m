Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbXISBAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbXISBAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 21:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbXISBAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 21:00:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59223 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbXISBAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 21:00:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=uP/nnYDD5zvdLKYk7BQIUIiltDtiDvlJ9GxAa2HJQ7t2+ubMu8MNGvpLfVasQjJVF
	p5oaO9lL/MjniiTVhby9A==
Message-ID: <6599ad830709181759u7d4ee5bav61f5bbaf978d90af@mail.gmail.com>
Date: Tue, 18 Sep 2007 17:59:51 -0700
From: "Paul Menage" <menage@google.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: cpuset trouble after hibernate
Cc: "Nicolas Capit" <nicolas.capit@imag.fr>, linux-kernel@vger.kernel.org,
       pj@sgi.com, "Simon Derr" <Simon.Derr@bull.net>
In-Reply-To: <20070909111856.GA4610@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070908204438.3bf03d85@localhost.localdomain>
	 <20070909111856.GA4610@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/07, Pavel Machek <pavel@ucw.cz> wrote:
>
> One of the cpus was unplugged during suspend... perhaps some
> save/restore is needed during hotplug/unplug?

Or else keep track separately in cpusets of

- cpus that the cpuset can run on
- cpus that the admin has specified for the cpu to run on

hotplug/hotunplug events would only affect the former; userspace would
only see/modify the latter. Then when hibernate is over and the CPUs
are hotplugged back in, things would be back as before.

Paul
