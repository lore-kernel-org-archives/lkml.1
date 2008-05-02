Return-Path: <linux-kernel-owner+w=401wt.eu-S936319AbYEBTxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936319AbYEBTxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936171AbYEBTwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:52:46 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39959 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934791AbYEBTwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:52:44 -0400
Date: Fri, 2 May 2008 21:52:32 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>,
       James Stafford <jstafford@ampltd.com>, Doug McLain <nostar@comcast.net>
Message-ID: <20080502195232.GA8502@enneenne.com>
References: <s5h8xamsuxd.wl%tiwai@suse.de> <1209547638-22570-1-git-send-email-giometti@linux.it> <s5h4p9jwmhr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h4p9jwmhr.wl%tiwai@suse.de>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] [ALSA] ice1724 - support for more that one codec.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 02:33:36PM +0200, Takashi Iwai wrote:
> At Wed, 30 Apr 2008 11:27:18 +0200,
> Rodolfo Giometti wrote:
> > 
> > Now it's possible to specify how many codes are present on the board by
> > using a new filed as follow:
> > 
> > 	ice->ac97_codecs = 4;
> > 
> > For backward compatibility if "ice->ac97_codecs" is set to zero, the patch
> > redefines it as "1".
> > 
> > Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> 
> Thanks for the patch.  The change looks OK to me, but please fix the
> issues reported by checkpatch.pl.

Ok, I'll do it ASAP.

> And, which hardware has multiple AC97 codecs?  I'd like rather apply
> it together.

I'm still working on it since I'd like to record from 4 channels at
time but I can't... here my custom settings:

static unsigned char int1410_eeprom[] __devinitdata = {
        [ICE_EEP1_CODEC]        = 0x1f,
        [ICE_EEP1_ACLINK]       = 0x00,
        [ICE_EEP1_I2SID]        = 0x01,
        [ICE_EEP1_SPDIF]        = 0x03,
        [ICE_EEP1_GPIO_MASK]    = 0xff,
        [ICE_EEP1_GPIO_STATE]   = 0xff,
        [ICE_EEP1_GPIO_DIR]     = 0xff,
};

static int __devinit snd_ice1712_int1410_init(struct snd_ice1712 *ice)
{
        printk("%s\n", __FUNCTION__);

        /* Set the pro AC97 codecs */
        ice->ac97_codecs = 4;

        /* Set the analog DACs/ADCs */
        ice->num_total_dacs = 8;
        ice->num_total_adcs = 8;

        return 0;
}

/* entry point */
struct snd_ice1712_card_info snd_ice1712_eurotech_cards[] __devinitdata =
{
        {
                .subvendor      = ICE1712_SUBDEVICE_INT1410,    /* a dummy id */
                .name           = "Eurotech INT 1410",
                .model          = "int1410",
                .chip_init      = snd_ice1712_int1410_init,
                .build_controls = snd_ice1712_int1410_add_controls,
                .no_mpu401      = 1,
                .eeprom_size    = sizeof(int1410_eeprom),
                .eeprom_data    = int1410_eeprom,
                .driver         = "int1410",
        },
        { } /* terminator */
};

But I'm a bit confused regarding how to enable such feature. Again,
should I use a multitrack audio recorder as ecasound or I can just use
arecord with some magic options? :)

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@linux.it
Embedded Systems                     phone:	+39 349 2432127
UNIX programming                     skype:     rodolfo.giometti
