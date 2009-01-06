Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbZAFNot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbZAFNot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 08:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZAFNok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 08:44:40 -0500
Received: from smtp4-ft1.vinci-energies.com ([81.252.86.87]:56139 "EHLO
	vinci-energies.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750889AbZAFNoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 08:44:39 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2009 08:44:38 EST
From: BARRE Sebastien <sbarre@sdelcc.com>
To: Ed Swierk <eswierk@aristanetworks.com>
CC: "i2c@lm-sensors.org" <i2c@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 6 Jan 2009 14:35:05 +0100
Subject: RE: [PATCH] rtc-ds1307: True SMBus compatibility
Thread-Topic: [PATCH] rtc-ds1307: True SMBus compatibility
Thread-Index: AclvXCQslBOZvTYER1mi3NS+Q0iv2QAolsBQ
Message-ID: <C1C62166118DFA4A8BBA01A2411F0D171224AECDC1@PRI-MBX-101.dom1.vinci-energies.net>
References: <1231176979.13443.19.camel@localhost.localdomain>
In-Reply-To: <1231176979.13443.19.camel@localhost.localdomain>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n06DirwM027711

Hello,

> -----Original Message-----
> From: Ed Swierk [mailto:eswierk@aristanetworks.com]
> Sent: Monday, January 05, 2009 6:36 PM
> To: i2c@lm-sensors.org; David Brownell; Alessandro Zummo; linux-
> kernel@vger.kernel.org; Andrew Morton; BARRE Sebastien
> Subject: [PATCH] rtc-ds1307: True SMBus compatibility
>
> Following up to Sebastien Barre's recent patch, here I go one step
> further, replacing i2c block transfers with SMBus byte transfers.
> Sticking to pure SMBus makes the driver work on our board, which has an
> nVidia SMBus controller driving a DS1339; nforce2 controllers
> unfortunately don't support any flavor of i2c block transfer.
>
> Reading or writing registers repeatedly until they stick is rather
> nauseating but I'm aiming for correctness if not elegance.  I would
> appreciate any suggestions for improvement.
>
> Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>

I've read your patch quicly, I will test it on my board as soon as possible.

> +static s32 ds1307_write_block_data(struct i2c_client *client, u8 command,
> +                                u8 length, const u8 *values)
> +{
> +     u8 currvalues[I2C_SMBUS_BLOCK_MAX];
> +     s32 ret;
> +     pr_debug("ds1307_write_block_data (length=%d)\n", length);

You can delete the next 3 lines, they are not useful:

> +     ret = ds1307_read_block_data_once(client, command, length, currvalues);
> +     if (ret < 0)
> +             return ret;

> +     do {
> +             s32 i, ret;
> +             for (i = 0; i < length; i++) {
> +                     ret = i2c_smbus_write_byte_data(client, command + i,
> +                                                     *(values + i));
> +                     if (ret < 0)
> +                             return ret;
> +             }
> +             ret = ds1307_read_block_data_once(client, command, length, currvalues);
> +             if (ret < 0)
> +                     return ret;
> +     } while (memcmp(currvalues, values, length));
> +     return length;
> +}

--
SÃ©bastien BarrÃ©
Bureau d'Ã©tude - DÃ©veloppement
SDEL ContrÃ´le Commande
D2A - Rue Nungesser et Coli
44860 Saint Aignan de Grand Lieu
FRANCE
TÃ©l : +33(0)2 40 84 50 88
Fax : +33(0)2 40 84 51 10
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
