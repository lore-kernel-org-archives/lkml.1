Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbYCLNhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbYCLNhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYCLNhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:37:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:54757 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbYCLNhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=jq7hSLewubrxc34mn2zKiDBVsQ/dbajt7lxmeOtgEgDQVjYZnMc5V06z9NqZA19q2Ylo4wqg+v5lmtegMZXQH5JQeiEZN2LrqalYl6oxhTF9o/T+Bjx4xXD7+Co6pLaby2F6wYVsfOKqubG/0dJGmgXbI1XIvHs1PE7bYaASWag=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 4/4] ide-tape: remove pipeline-specific code from idetape_add_chrdev_read_request()
Date: Wed, 12 Mar 2008 14:51:23 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com> <200803110025.51072.bzolnier@gmail.com> <20080312055803.GD4266@gollum.tnic>
In-Reply-To: <20080312055803.GD4266@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803121451.23925.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 12 March 2008, Borislav Petkov wrote:

[...]

> > > the read request's buffer directly thru idetape_queue_rw_tail()
> > > 
> > > 3. Do next request buffer allocation (tape->merge_stage)
> > 
> > Isn't idetape_init_read() taking care of 3.?
> 
> i wanted to have the whole handling at one place and let _init_read() only
> prepare the read. Now we don't allocate any new tape->merge_stage anymore,
> which is wrong. Originally, this happened in _init_read(), however, if we do
> idetape_queue_rw_tail(), we should alloc the new stage _after_ queueing the

The original driver doesn't do this - it just calls idetape_queue_rw_tail(),
could it be a bug in the original driver?

[ ditto for idetape_queue_rw_tail() for writes ]

> request, which means it cannot happen _init_read() now and should take place
> afterwards, i.e. as it was in the original patch, or?
