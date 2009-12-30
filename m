Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZL3LHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZL3LHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 06:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZL3LHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 06:07:37 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:35072 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbZL3LHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 06:07:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bhAyrc6VvBjO3/aNADvM2KVEYanbRuSMXZRXmLiskVdVJ4rXBzpgf2aSaLEgCqjqhE
         06BBejjY6ZyrvlcM9Cn1a5KHZIPKwTZPCfQVeVUdWvGopABMXyxlogvoGNsikA2mqk6A
         MWERbVXDedwhWQqmzRJuJWJugQUE6ZEMQTMhc=
Date: Wed, 30 Dec 2009 03:07:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Vikram Dhillon <dhillonv10@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
Message-ID: <20091230110731.GA3050@core.coreip.homeip.net>
References: <20091228172651.GE4994@basil.fritz.box>
 <1262030653.15368.37.camel@wall-e>
 <20091228204003.GH4994@basil.fritz.box>
 <1262076056.23095.21.camel@wall-e>
 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
 <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
 <20091230020830.GA7049@core.coreip.homeip.net>
 <1262165390.4153.3.camel@wall-e>
 <20091230104325.GA2214@core.coreip.homeip.net>
 <1262170336.9121.4.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262170336.9121.4.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 11:52:15AM +0100, Stefani Seibold wrote:
> Am Mittwoch, den 30.12.2009, 02:43 -0800 schrieb Dmitry Torokhov:
> > On Wed, Dec 30, 2009 at 10:29:50AM +0100, Stefani Seibold wrote:
> > >
> > I do not need to try the new behavior - you explained it quite well.
> > You changed the old API to allow processing multiple records at a time
> > and it does not quite work the way you want with Andi's patch. Now the
> 
> Wrong, i did not change the behavior of the old API. It is exactly the
> same at is was!!!!

You said:

"The kfifo_in() and kfifo_out() len parameter is than in the meaning
of elements not bytes."

This is the change from the existing API which works with _bytes_:

/**
 * kfifo_in - puts some data into the FIFO
 * @fifo: the fifo to be used.
 * @from: the data to be added.
 * @len: the length of the data to be added.
 *
 * This function copies at most @len bytes from the @from buffer into
                                ^^^^^^^^^^
 * the FIFO depending on the free space, and returns the number of
 * bytes copied.


> 
> > question is: when working with _records_ does anyone really want to
> > put/get more than 1 record at a time? My answer would be "no, most users
> 
> Your answer is wrong. All current user depend on it, because it
> (miss)use a byte stream to store values other than bytes to it.

However all of them that I know of deposit and fetch exactly one record
at a time (the fact that they are more than 1 byte is immaterial).

>  
> > work with 1 record at a time". Thus your changes to the old API are not
> > needed.
> > 
> 
> A lot of hot air...

*sigh* That's an iron-clad argument right there.

-- 
Dmitry
