Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbXAaKj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbXAaKj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbXAaKj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:39:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:62762 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955AbXAaKj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:39:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=FY68cmsVifIkfMdIrVGrFWLs1y207g7oAgLppnN+yZfVMlXOI2nW/IqiLYh7cZ6W6RDmbIMw6BYQ6EcyQZIRhY0oCfy9c8QUu6HKSS7c3drC5zYM7F1x46xKoxow2PgYmdxa+jJEOjhYWvR8aDtAqXV+eVsl80A+WFjSHTcy5Es=
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [RFC] rfkill - Add support for input key to control wireless radio
Date: Wed, 31 Jan 2007 11:39:09 +0100
User-Agent: KMail/1.9.5
Cc: Dmitry Torokhov <dtor@insightbb.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "John Linville" <linville@tuxdriver.com>,
       Jiri Benc <jbenc@suse.cz>, Lennart Poettering <lennart@poettering.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       Larry Finger <Larry.Finger@lwfinger.net>
References: <200612031936.34343.IvDoorn@gmail.com> <20070130194023.4e2d5305@localhost.localdomain>
In-Reply-To: <20070130194023.4e2d5305@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311139.09452.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > +	/*
> > +	 * Pointer to rfkill structure
> > +	 * that was filled in by key driver.
> > +	 */
> > +	struct rfkill *rfkill;
> 
> Since rfkill is basically a function pointer table,
> can it be made const?

Sounds good to me.

> > +	/*
> > +	 * Once key status change has been detected, the toggled
> > +	 * field should be set to indicate a notification to
> > +	 * user or driver should be performed.
> > +	 */
> > +	int toggled;
> > +
> > +	/*
> > +	 * Current state of the device radio, this state will
> > +	 * change after the radio has actually been toggled since
> > +	 * receiving the radio key event.
> > +	 */
> > +	int radio_status;
> > +
> > +	/*
> > +	 * Current status of the key which controls the radio,
> > +	 * this value will change after the key state has changed
> > +	 * after polling, or the key driver has send the new state
> > +	 * manually.
> > +	 */
> > +	int key_status;
> 
> 
> Maybe turn these bits into a bit values (set_bit/clear_bit) in an unsigned long.

Will do.

> > +	/*
> > +	 * Input device for this key,
> > +	 * we also keep track of the number of
> > +	 * times this input device is open. This
> > +	 * is important for determining to whom we
> > +	 * should report key events.
> > +	 */
> > +	struct input_dev *input;
> > +	unsigned int open_count;
> 
> atomic on open_count?

There seems to have gone something wrong with the patch,
latest version should have had this field removed.

> > +	/*
> > +	 * Name of this radio type.
> > +	 */
> > +	char *name;
> 
> const?

Will do.

> > +	/*
> > +	 * All access to the master structure
> > +	 * and its children (the keys) are protected
> > +	 * by this key lock.
> > +	 */
> > +	struct semaphore key_sem;
> 
> mutex instead of semaphort

Strange, this should have already be fixed. :S

> > +	/*
> > +	 * Work structures for periodic polling,
> > +	 * as well as the scheduled radio toggling.
> > +	 */
> > +	struct work_struct toggle_work;
> > +	struct work_struct poll_work;
> 
> delayed_rearming_work instead?

Same here, rfkill should already have the new workqueue api...

I'll resubmit this within a few moments.

Thanks

Ivo
