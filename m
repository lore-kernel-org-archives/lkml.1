Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZFXVRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZFXVRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZFXVQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:16:58 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:45996 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbZFXVQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:16:57 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/3] Return ENODEV instead of EINVAL when trying to open ACM device.
Date: Wed, 24 Jun 2009 23:17:04 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       linux-usb@vger.kernel.org
References: <1245843077-4442-1-git-send-email-cascardo@holoscopio.com> <20090624204015.GD28516@suse.de>
In-Reply-To: <20090624204015.GD28516@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906242317.05307.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. Juni 2009 22:40:15 schrieb Greg KH:
> On Wed, Jun 24, 2009 at 08:31:15AM -0300, Thadeu Lima de Souza Cascardo wrote:
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > ---
> >  drivers/usb/class/cdc-acm.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
> > index 38bfdb0..02eb60b 100644
> > --- a/drivers/usb/class/cdc-acm.c
> > +++ b/drivers/usb/class/cdc-acm.c
> > @@ -550,7 +550,7 @@ static void acm_waker(struct work_struct *waker)
> >  static int acm_tty_open(struct tty_struct *tty, struct file *filp)
> >  {
> >  	struct acm *acm;
> > -	int rv = -EINVAL;
> > +	int rv = -ENODEV;
>
> Why is this needed?

The current error return is incorrect. If the table entry is gone, the
device has been disconnected, hence -ENODEV.

	Regards
		Oliver
Acked-by: Oliver Neukum <oliver@neukum.org>

