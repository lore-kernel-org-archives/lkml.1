Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005Ab0A0QJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0A0QJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013Ab0A0QJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:09:35 -0500
Received: from banach.math.auburn.edu ([131.204.45.3]:59960 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab0A0QJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:09:35 -0500
Date: Wed, 27 Jan 2010 10:25:07 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: linux-next: v4l-dvb tree build warning
In-Reply-To: <20100127121223.9af2253f.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1001271010580.16311@banach.math.auburn.edu>
References: <20100127121223.9af2253f.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jan 2010, Stephen Rothwell wrote:

> Hi Mauro,
>
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
>
> drivers/media/video/gspca/sq905c.c: In function 'sd_config':
> drivers/media/video/gspca/sq905c.c:207: warning: unused variable 'i'
>
> Introduced by commit 6436e86d8920520f6650bedaa816ed596c7c30b7 ("V4L/DVB
> (14006): gscpa_sq905c: Better detection of CIF resolution cameras").
>
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

Hmmm. Indeed this is there. The reason I have been saying that it can't be 
there is, my local copy of sq905c.c had at lines


/* This function is called at probe time just before sd_init */
static int sd_config(struct gspca_dev *gspca_dev,
 		const struct usb_device_id *id)
{
 	struct cam *cam = &gspca_dev->cam;
 	struct sd *dev = (struct sd *) gspca_dev; (here is line 207)
 	int ret;

But, having just done a pull, I have now a file which agrees with the tree 
of Hans de Goede, and it says in it

/* This function is called at probe time just before sd_init */
static int sd_config(struct gspca_dev *gspca_dev,
 		const struct usb_device_id *id)
{
 	struct cam *cam = &gspca_dev->cam;
 	struct sd *dev = (struct sd *) gspca_dev;
 	int i, ret;				  (here is line 207)

Amazing, and I have at this point no idea how it got in there. Again, it 
is not present in the copy I have been staring at for the last several 
days, every time that this issue has come up.

(me scratches head)

Definitely, the declaration of "i" has to come out because it is true it 
is not used.

Hans, what is the quickest and most efficient way to get this fixed? I 
suspect people are in a hurry.


Theodore Kilgore
