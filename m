Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYH0DUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYH0DUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 23:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYH0DTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 23:19:52 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38643 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbYH0DTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 23:19:52 -0400
Date: Tue, 26 Aug 2008 22:19:48 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       zohar@us.ibm.com, dvelarde@us.ibm.com, safford@us.ibm.com
Subject: Re: [PATCH][resubmit] TPM: update char dev BKL pushdown
Message-ID: <20080827031948.GA5184@us.ibm.com>
References: <1219784185.4768.6.camel@blackbox> <20080826220823.509571fd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826220823.509571fd@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alan Cox (alan@lxorguk.ukuu.org.uk):
> > +	atomic_set(&chip->is_open, 1);
> > +	get_device(chip->dev); /* protect from chip disappearing */
> 
> Why not just use test_and_set_bit() ? You seem to be abusing atomic_t to
> achieve this.

Good point.  Or heck just make it a simple flag.  Earlier I thought there
was a place where driver_lock was taken just to do num_opens--, and so
replacing the int num_opens with an atomic_t seemed worthwhile.  But since
is_open is a boolean and now seems to be always protected by driver_lock,
a flag seems best.

-serge
