Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZIABhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZIABhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 21:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZIABhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 21:37:51 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:59000 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbZIABhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 21:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=bJwhlDJgwfiFGE3+ghS754meWa4kBvj6ll0fbTHzJOO8f/jdprsQrBIlg9xya9nuYM
         DqIp0J/fCToTaeS+13jyfTas89imJzkx6Bd0eC1+K88iytskNQyxL93qNgM5fVq0GIK7
         r1wktEgBgLGW87ZEI1hmff3UeRVo9h10b2QpA=
Date: Mon, 31 Aug 2009 18:37:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Georgi Chorbadzhiyski <gf@unixsol.org>
Cc: Henk Vergonet <henk.vergonet@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, usbb2k-api-dev@nongnu.org
Subject: Re: input: Phone buttons in USB handsets/phones
References: <4A9AE758.2060106@unixsol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9AE758.2060106@unixsol.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090901021024.EC446526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 11:55:52PM +0300, Georgi Chorbadzhiyski wrote:
> Hi guys, I'm patching yealink.c to support p4k phone and
> I'm wondering what to do about the extra buttons that are
> found the phone [1] but are not defined as KEY_xxxxxx in
> input.h?
> 
> For example the phone that I'm working with have these
> buttons that do not have matching definitions in input.h:
> 
>   FLASH
>   REDIAL

There is nothing thst stops us from adding more KEY_* definitons to
input.h as long as it is shown that will be used by drivers and
applications.

>   SPEAKER

This should probably be a switch, not a key.


> 
> for testing purposes I mapped them to f, r and s
> but that's probably not what should be done.
> 
> So what to do about them?
> 
> [1]: http://www.von-phone.com/prodimages/P4K-functions.jpg
> 
> Right now mapping looks like this:
> 
> +
> +/*
> + * USB-P4K button layout:
> + *
> + *        IN   up    OUT
> + *      VOL+           DEL
> + *       VOL- down   DIAL
> + *
> + *       1      2      3
> + *       4      5      6
> + *       7      8      9
> + *       *      0      #
> + *
> + *    HELP     (S)    SEND
> + *      FLASH       REDIAL
> + *
> + * The "up" and "down" keys, are one big key
> + * The (S) is one big green key with speaker picture on it
> + */
> +static int map_p4k_to_key(int scancode)
> +{
> +	switch(scancode) {			/* phone key:	*/
> +	case 0x34: return KEY_LEFT;		/*   IN		*/
> +	case 0x32: return KEY_UP;		/*   up		*/
> +	case 0x10: return KEY_RIGHT;		/*   OUT	*/
> +	case 0x30: return KEY_DOWN;		/*   down	*/
> +	case 0x31: return KEY_VOLUMEUP;		/*   VOL+	*/
> +	case 0x40: return KEY_VOLUMEDOWN;	/*   VOL-	*/
> +	case 0x33: return KEY_BACKSPACE;	/*   DEL	*/
> +	case 0x00: return KEY_ENTER;		/*   DIAL	*/
> +	case 0x21: return KEY_1;		/*   1		*/
> +	case 0x11: return KEY_2;		/*   2 		*/
> +	case 0x01: return KEY_3;		/*   3		*/
> +	case 0x22: return KEY_4;		/*   4		*/
> +	case 0x12: return KEY_5;		/*   5		*/
> +	case 0x02: return KEY_6;		/*   6		*/
> +	case 0x23: return KEY_7;		/*   7		*/
> +	case 0x13: return KEY_8;		/*   8		*/
> +	case 0x03: return KEY_9;		/*   9		*/
> +	case 0x24: return KEY_KPASTERISK; 	/*   *		*/
> +	case 0x14: return KEY_0;		/*   0		*/
> +	case 0x04: return KEY_LEFTSHIFT |
> +			  KEY_3 << 8;		/*   #		*/
> +	case 0x05: return KEY_HELP; 		/*   HELP	*/
> +	case 0x15: return KEY_F;   		/*   FLASH	*/
> +	case 0x20: return KEY_S;  		/*   SPEAKER	*/
> +	case 0x25: return KEY_SEND; 		/*   SEND	*/
> +	case 0x44: return KEY_R;    		/*   REDIAL	*/
> +	}
> +	return -EINVAL;
> +}
> 
> A related question - cm109 driver uses KEY_NUMERIC_xxx constants
> but since yealink is an older driver (merged in 2.6.14-rc1) it
> returns KEY_0..KEY_9, KPASTERISK and a hack to return #.
> 
> Is it a good idea to make yealink return KEY_NUMERIC_xxxx codes
> since they are specially designed for numeric keypads (phones).
> 

It would be great but I am concerned about breaking existing users;
I will gladly accept the patch that would add module option causing
yealink to start using KEY_NUMERIC_* and also allowing changing keymap
from userspace.

> On one hand this will unify somehow codes returned by cm109
> (supports at least 5 different usb phone models) and yealink
> (lots of nice usb phones) but on the other hand support for
> KEY_NUMERIC_xxx should be added to every application that
> right now is working fine with yealink driver (but not cm109).
> Right now returning normal 1,2,3,etc makes testing the driver
> a lot easier. Just plug the phone and enter some numbers.
> In this case KEY_NUMERIC_xxxx codes are PITA.
> 

Just fix your keymaps. It should be done just once.

> So I'm a bit stuck at what to do, should I patch yealink
> to return NUMERIC_xxx codes

Patch yealink (but keep compatibility by default), advise application
users to switch to new keymap style.

> or switch cm109 to returning
> KEY_1..KEY_9, KEY_ASTERISK, etc?

No, because then it will not work for French users (or anyone whose
default keymap has digits in _upper_ register). That was the reson for
introducing KEY_NUMERIC_* (KEY_1 & are are affected by keymap and shift
state, KEY_KP1 & co. are affected by numlock state).

-- 
Dmitry
