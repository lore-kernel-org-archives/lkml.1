Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZJNHPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZJNHPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbZJNHPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:15:10 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:58349 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbZJNHPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ui1HkyzziLJWn8tV1VE4PnO0ckGKqv7e10FQ/OJwwTxn0E5G7xLBvJw6o7nOvVELH+
         jXvX6PyaY+B37/fFXhC3ybWHaIYZaIzNxdMHwtHeoNgvLabdYX0ry3tWVltPkZzqNAwF
         7bXgaUo8Y3FY8+qpJ2zOIC+HdF9Ie196FM4Bo=
Date: Wed, 14 Oct 2009 00:14:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: iceberg <strakh@ispras.ru>, Vojtech Pavlik <vojtech@suse.cz>,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [BUG] ati_remote2.c: possible mutex_lock without mutex_unlock
Message-ID: <20091014071428.GA5318@core.coreip.homeip.net>
References: <1255456327.22233.0@pamir> <alpine.LSU.2.00.0910131736571.8582@wotan.suse.de> <20091014062902.GA2971@core.coreip.homeip.net> <alpine.LSU.2.00.0910140906280.8582@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0910140906280.8582@wotan.suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 09:11:06AM +0200, Jiri Kosina wrote:
> On Tue, 13 Oct 2009, Dmitry Torokhov wrote:
> 
> > Umm, I don't like assuming that EAGAIN can only mean that 
> > mutex_lock_interruptible() failed, seq_file core may theoretically 
> > return -EAGAIN too. In fact, looking through seq_file.c traverse() does 
> > return -EAGAIN in certain cases...
> 
> Damn, you are right -- I explicitly checked for this, but have completely 
> overlooked the "Eoveflow:" branch in traverse(), which returns EAGAIN. So 
> my previous patch is of course incorrect.
> 
> > Input: fix locking issue in /proc/bus/input/ handlers
> > 
> > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > 
> > input_devices_seq_start() uses mutex_lock_interruptible() to acquire
> > the input_mutex, but doesn't properly handle the situation when the
> > call fails (for example due to interrupt). Instead of returning NULL
> > (which indicates that there is no more data) we should return
> > ERR_PTR()-encoded error.
> > 
> > We also need explicit flag indicating whether input_mutex was acquired
> > since input_devices_seq_stop() is called whether input_devices_seq_start()
> > was successful or not.
> > 
> > The same applies to input_handlers_seq_start().
> > 
> > Reported-by: iceberg <strakh@ispras.ru>
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> 
> Yup, looks OK to me.
> 

Putting you as "Reviewed-by.." then, OK?

-- 
Dmitry
