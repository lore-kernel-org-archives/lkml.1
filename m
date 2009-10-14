Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbZJNHRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbZJNHRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbZJNHRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:17:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbZJNHRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:17:08 -0400
Date: Wed, 14 Oct 2009 09:16:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: iceberg <strakh@ispras.ru>, Vojtech Pavlik <vojtech@suse.cz>,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [BUG] ati_remote2.c: possible mutex_lock without mutex_unlock
In-Reply-To: <20091014071428.GA5318@core.coreip.homeip.net>
Message-ID: <alpine.LSU.2.00.0910140915440.8582@wotan.suse.de>
References: <1255456327.22233.0@pamir> <alpine.LSU.2.00.0910131736571.8582@wotan.suse.de> <20091014062902.GA2971@core.coreip.homeip.net> <alpine.LSU.2.00.0910140906280.8582@wotan.suse.de> <20091014071428.GA5318@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Dmitry Torokhov wrote:

> > > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > 
> > > input_devices_seq_start() uses mutex_lock_interruptible() to acquire
> > > the input_mutex, but doesn't properly handle the situation when the
> > > call fails (for example due to interrupt). Instead of returning NULL
> > > (which indicates that there is no more data) we should return
> > > ERR_PTR()-encoded error.
> > > 
> > > We also need explicit flag indicating whether input_mutex was acquired
> > > since input_devices_seq_stop() is called whether input_devices_seq_start()
> > > was successful or not.
> > > 
> > > The same applies to input_handlers_seq_start().
> > > 
> > > Reported-by: iceberg <strakh@ispras.ru>
> > > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > 
> > Yup, looks OK to me.
> 
> Putting you as "Reviewed-by.." then, OK?

Sure, feel free to do that.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
