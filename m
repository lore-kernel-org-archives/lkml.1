Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbYAPI2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbYAPI2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 03:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYAPI2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 03:28:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:50193 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYAPI2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:28:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kiNBYkbT2Xdi+jUbpQIhKueqDU6R9374ELxIVfzdE/Dow9wHYJrX8v/6kHPf4ZFLIHeJQTptitEowu5/tmQ4UAO1VF0NDM6J05ZhX9k5ePbfxsakR9JMMg2IeYd+6FESaBK5NzCzWvbGPFaLKiCt9bJI4quI1pUpRIBBnQNadjE=
Date: Wed, 16 Jan 2008 09:34:43 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de, david-b@pacbell.net,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080116083442.GA2307@ff.dom.local>
References: <20080112100515.GA2956@darkstar.te-china.tietoenator.com> <20080115091527.GB3186@darkstar.te-china.tietoenator.com> <20080115135604.GD1696@ff.dom.local> <a8e1da0801151703w52df227en42eae85e75d5017f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801151703w52df227en42eae85e75d5017f@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 09:03:03AM +0800, Dave Young wrote:
...
> The lockdep warining was posted in the below thread, actually, I have
> built and run this patced kernel for several days, there's no more
> warnings.
> http://lkml.org/lkml/2008/1/3/2

Right... But, with something like this:

... have_some_fun(... cls)
{
	mutex_lock_nested(&cls->mutex, SINGLE_DEPTH_NESTING);
	have_other_fun(cls);
	mutex_unlock(&cls->mutex);

}

... have_more_fun(...)
{
	...

	mutex_init(&cls->mutex);

	mutex_lock(&cls->mutex);
	have_some_fun(cls);
	mutex_unlock(&cls->mutex);
}

probably you wouldn't get any lockdep warning too...

Of course, if we know all the locking is right such proper lockdep
annotating shouldn't matter too much. (And of course this could be
improved later.)

Regards,
Jarek P.
