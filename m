Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYDIRA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYDIRA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYDIRAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:00:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:59517 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYDIRAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=aDSkJ1oPY/fMBxTyt6AgeBVZqXX9vegvauw2j5xuT9b7Budmtn/vx5UQwb6kwgK6r6/sXBv5WA8Vvdp1NH6ftqS7RVZ5VrDMaCNTuzoQvheCHL7xgx90s7UwICay1TH35MgveBvkvC5XYOjUWBkx9oPbDm3aVgaKSLBlvnhevd8=
Message-ID: <37219a840804091000y34ba76e2x4937600ae7bda3a5@mail.gmail.com>
Date: Wed, 9 Apr 2008 13:00:05 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: harvey.harrison@gmail.com
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace remaining __FUNCT ION__ occurences
Cc: akpm@linux-foundation.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, abraham.manu@gmail.com,
       mchehab@infradead.org
In-Reply-To: <37219a840804040809q470a64fdmed95e21bd51c23b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204613661.22933.110.camel@brick> <47F536FF.8060105@linuxtv.org>
	 <37219a840804040809q470a64fdmed95e21bd51c23b0@mail.gmail.com>
X-Google-Sender-Auth: 10b4f7cbcdc2bf74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2008 at 11:09 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> On Thu, Apr 3, 2008 at 3:58 PM,  <mkrufky@linuxtv.org> wrote:
>  >  Harvey,
>  >
>  >  If you decide to move forward with these cleanups now, please keep the
>  >  previous discussion in mind -- please generate the changesets against
>  >  the v4l-dvb master repository, hosted on linuxtv.org, and please
>  >  separate the changesets by each level of the directory tree hierarchy.
>
>  Harvey,
>
>  You sent in three patches, video/ , common/ , and dvb/ ... but these
>  patches are way too large.
>
>  Please break these down by each level of the directory tree hierarchy,
>  like I asked previously.
>
>  Make one patch for files inside media/video/*.[ch]
>  make one patch for files inside media/video/cx88/*.[ch]
>  make one patch for files inside media/video/saa7134/*.[ch]
>  [...]
>  make one patch for files inside media/dvb/b2c2/*.[ch]
>  make one patch for files inside media/dvb/frontends/*.[ch]
>  [...]
>  etc.

Harvey,

I have received your entire patchset.  Some patches have already been
merged into our development tree, others have been dropped, since some
of individual driver maintainers have decided to remove the
__FUNCTION__ macro from their source code altogether, rather than
accept this change.

I have merged the remaining pending patches into a mercurial tree,
hosted on linuxtv.org:

http://linuxtv.org/hg/~mkrufky/function-func

Please note that I had to manually apply patches 8, 11 and 13, since
you generated your changes against the git repository rather than the
official v4l-dvb development repository hosted on linuxtv.org.

I must stress this -- all v4l-dvb patches, ESPECIALLY
codingstyle-cleanups (due to the nature of those patches, touching
many many files at once), should always be generated against the
v4l-dvb master development repository hosted on linuxtv.org.

Now, I have a question.....

About this change from __FUNCTION__ to __func__ , I understand that
this change is being done kernel-wide.  At first, I had blindly
accepted this change as a kernel-janitor "cleanup", until it was
pointed out to me last night, that older compilers do not support
__func__.  Sure, one can always do the following for compat:

#ifndef __func__
 #define __func__ __FUNCTION__
#endif /* __func__ */

...but the question is raised, why are we making this change in the first place?

Don't get me wrong -- as I said before, I understand that this change
is kernel-wide, and I am not arguing against it.  I will continue on
to have this merged into 2.6.26.  I would just like to see a link that
points to a discussion thread on LKML that explains the reasons for
this change, and where this change was globally agreed to.  Again -- I
am not challenging these patches.  I merely want to read more
information as to why we are making this move.

In the meanwhile, below is the checkpatch.pl fallout after applying
your __FUNCTION__ to __func__ series.  Since you are working on these
codingstyle cleanups anyway, I'd imagine that you won't mind fixing
these checkpatch.pl "errors" and "warnings" before we merge these
changes.

I understand if you don't want to alter code that you may not be
directly involved in, but I am sure you will have no trouble at least
fixing the "comma after space" and "line over 80 characters" cases.

Please generate the additional cleanups against the mercurial tree
that I merged your previous series to:

http://linuxtv.org/hg/~mkrufky/function-func

Also, please generate the codingstyle cleanup patches individually
based on the directory structure, just as you did in your last series.

See below for the checkpatch.pl "errors" and "warnings".

Regards,

Mike

ERROR: need space after that ',' (ctx:VxV)
#78: FILE: linux/drivers/media/dvb/b2c2/flexcop-dma.c:115:
+     deb_info("%s\n",__func__);
                     ^
ERROR: need space after that ',' (ctx:VxV)
#87: FILE: linux/drivers/media/dvb/b2c2/flexcop-dma.c:165:
+     deb_info("%s\n",__func__);
                     ^
WARNING: printk() should include KERN_ facility level
#99: FILE: linux/drivers/media/dvb/b2c2/flexcop-sram.c:93:
+                     printk("%s: SRAM timeout\n", __func__);

WARNING: printk() should include KERN_ facility level
#108: FILE: linux/drivers/media/dvb/b2c2/flexcop-sram.c:118:
+                     printk("%s: SRAM timeout\n", __func__);

WARNING: printk() should include KERN_ facility level
#117: FILE: linux/drivers/media/dvb/b2c2/flexcop-sram.c:130:
+                     printk("%s: SRAM timeout\n", __func__);

WARNING: line over 80 characters
#126: FILE: linux/drivers/media/dvb/b2c2/flexcop-sram.c:243:
+             ddprintk("%s: dw_sram_type = %x\n", __func__,
adapter->dw_sram_type);

WARNING: line over 80 characters
#133: FILE: linux/drivers/media/dvb/b2c2/flexcop-sram.c:249:
+             ddprintk("%s: dw_sram_type = %x\n", __func__,
adapter->dw_sram_type);

WARNING: line over 80 characters
#226: FILE: linux/drivers/media/dvb/bt8xx/dst.c:1293:
+     //dprintk("%s: Getting Signal strength and other parameters\n", __func__);

ERROR: do not use C99 // comments
#226: FILE: linux/drivers/media/dvb/bt8xx/dst.c:1293:
+     //dprintk("%s: Getting Signal strength and other parameters\n", __func__);

WARNING: line over 80 characters
#238: FILE: linux/drivers/media/dvb/bt8xx/dst_ca.c:39:
+                     printk(KERN_ERR "%s: " format "\n", __func__ , ##arg);  \

WARNING: line over 80 characters
#241: FILE: linux/drivers/media/dvb/bt8xx/dst_ca.c:41:
+                     printk(KERN_NOTICE "%s: " format "\n", __func__
, ##arg);       \

#244: FILE: linux/drivers/media/dvb/bt8xx/dst_ca.c:43:
+                     printk(KERN_INFO "%s: " format "\n", __func__ , ##arg); \

WARNING: line over 80 characters
#247: FILE: linux/drivers/media/dvb/bt8xx/dst_ca.c:45:
+                     printk(KERN_DEBUG "%s: " format "\n", __func__ ,
##arg);        \

WARNING: line over 80 characters
#256: FILE: linux/drivers/media/dvb/bt8xx/dst_ca.c:165:
+             (state->messages[10] << 8) | state->messages[11],
__func__, (char *)(&state->messages[12]));

WARNING: printk() should include KERN_ facility level
#268: FILE: linux/drivers/media/dvb/bt8xx/dvb-bt8xx.c:675:
+                     printk("%s: Could not find a Twinhan DST.\n", __func__);

WARNING: line over 80 characters
#349: FILE: linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c:267:
+                     dprintk("%s succeeded timeout:%lu\n", __func__,
jiffies - start);

WARNING: no space between function name and open parenthesis '('
#526: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:143:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#535: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:179:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#544: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:245:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#571: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:611:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#580: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:679:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#589: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:777:
+     dprintk ("%s\n", __func__);

WARNING: line over 80 characters
#598: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:909:
+                             printk("%s switch command: 0x%04lx\n",
__func__, cmd);

WARNING: printk() should include KERN_ facility level
#598: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:909:
+                             printk("%s switch command: 0x%04lx\n",
__func__, cmd);

WARNING: no space between function name and open parenthesis '('
#616: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:1051:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#625: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:1068:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#634: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:1109:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#643: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:1149:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#652: FILE: linux/drivers/media/dvb/dvb-core/dvb_frontend.c:1183:
+     dprintk ("%s\n", __func__);

WARNING: printk() should include KERN_ facility level
#668: FILE: linux/drivers/media/dvb/dvb-core/dvb_net.c:997:
+             printk("%s: BUG %d\n", __func__, __LINE__);

WARNING: line over 80 characters
#693: FILE: linux/drivers/media/dvb/dvb-core/dvb_net.c:1029:
+                             dprintk("%s: set multi_secfilter[%d]\n",
__func__, i);

ERROR: need space after that ',' (ctx:VxV)
#823: FILE: linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c:155:
+     deb_fe("%s\n",__func__);
                   ^

ERROR: need space after that ',' (ctx:VxV)
#832: FILE: linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c:170:
+     deb_fe("%s\n",__func__);
                   ^

ERROR: need space after that ',' (ctx:VxV)
#844: FILE: linux/drivers/media/dvb/dvb-usb/m920x.c:480:
+     deb("%s\n",__func__);
                ^

ERROR: need space after that ',' (ctx:VxV)
#853: FILE: linux/drivers/media/dvb/dvb-usb/m920x.c:492:
+     deb("%s\n",__func__);
                ^

ERROR: need space after that ',' (ctx:VxV)
#862: FILE: linux/drivers/media/dvb/dvb-usb/m920x.c:504:
+     deb("%s\n",__func__);
                ^

ERROR: need space after that ',' (ctx:VxV)
#871: FILE: linux/drivers/media/dvb/dvb-usb/m920x.c:516:
+     deb("%s\n",__func__);
                ^

ERROR: need space after that ',' (ctx:VxV)
#880: FILE: linux/drivers/media/dvb/dvb-usb/m920x.c:526:
+     deb("%s\n",__func__);
                ^

ERROR: need space after that ',' (ctx:VxV)
#889: FILE: linux/drivers/media/dvb/dvb-usb/m920x.c:536:
+     deb("%s\n",__func__);
                ^

ERROR: need space after that ',' (ctx:VxV)
#901: FILE: linux/drivers/media/dvb/dvb-usb/vp702x-fe.c:70:
+     deb_fe("%s\n",__func__);
                   ^

ERROR: need space after that ',' (ctx:VxV)
#910: FILE: linux/drivers/media/dvb/dvb-usb/vp702x-fe.c:124:
+     deb_fe("%s\n",__func__);
                   ^

ERROR: need space after that ',' (ctx:VxV)
#919: FILE: linux/drivers/media/dvb/dvb-usb/vp702x-fe.c:186:
+     deb_fe("%s\n",__func__);
                   ^

ERROR: need space after that ',' (ctx:VxV)
#927: FILE: linux/drivers/media/dvb/dvb-usb/vp702x-fe.c:193:
+     deb_fe("%s\n",__func__);
                   ^

ERROR: need space after that ',' (ctx:VxV)
#935: FILE: linux/drivers/media/dvb/dvb-usb/vp702x-fe.c:200:
+     deb_fe("%s\n",__func__);
                   ^

ERROR: need space after that ',' (ctx:VxV)
#944: FILE: linux/drivers/media/dvb/dvb-usb/vp702x-fe.c:211:
+     deb_fe("%s\n",__func__);
                   ^

ERROR: need space after that ',' (ctx:VxV)
#953: FILE: linux/drivers/media/dvb/dvb-usb/vp702x-fe.c:233:
+     deb_fe("%s\n",__func__);
                   ^

ERROR: need space after that ',' (ctx:VxV)
#962: FILE: linux/drivers/media/dvb/dvb-usb/vp702x-fe.c:241:
+     deb_fe("%s\n",__func__);
                   ^

ERROR: need space after that ',' (ctx:VxV)
#971: FILE: linux/drivers/media/dvb/dvb-usb/vp702x-fe.c:266:
+     deb_fe("%s\n",__func__);
                   ^

WARNING: no space between function name and open parenthesis '('
#1016: FILE: linux/drivers/media/dvb/frontends/cx22700.c:76:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#1032: FILE: linux/drivers/media/dvb/frontends/cx22700.c:95:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#1041: FILE: linux/drivers/media/dvb/frontends/cx22700.c:108:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#1050: FILE: linux/drivers/media/dvb/frontends/cx22700.c:130:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#1059: FILE: linux/drivers/media/dvb/frontends/cx22700.c:194:
+     dprintk ("%s\n", __func__);

WARNING: printk() should include KERN_ facility level
#1092: FILE: linux/drivers/media/dvb/frontends/cx22702.c:111:
+             printk("%s: readreg error (ret == %i)\n", __func__, ret);

WARNING: no space between function name and open parenthesis '('
#1101: FILE: linux/drivers/media/dvb/frontends/cx22702.c:198:
+     dprintk ("%s(%d)\n", __func__, enable);

WARNING: no space between function name and open parenthesis '('
#1110: FILE: linux/drivers/media/dvb/frontends/cx22702.c:231:
+             dprintk ("%s: invalid bandwidth\n",__func__);

ERROR: need space after that ',' (ctx:VxV)
#1110: FILE: linux/drivers/media/dvb/frontends/cx22702.c:231:
+             dprintk ("%s: invalid bandwidth\n",__func__);
                                                ^

ERROR: need space after that ',' (ctx:VxV)
#1119: FILE: linux/drivers/media/dvb/frontends/cx22702.c:253:
+             dprintk("%s: Autodetecting\n",__func__);
                                           ^

WARNING: no space between function name and open parenthesis '('
#1128: FILE: linux/drivers/media/dvb/frontends/cx22702.c:264:
+                     dprintk ("%s: invalid constellation\n",__func__);

ERROR: need space after that ',' (ctx:VxV)
#1128: FILE: linux/drivers/media/dvb/frontends/cx22702.c:264:
+                     dprintk ("%s: invalid constellation\n",__func__);
                                                            ^

WARNING: no space between function name and open parenthesis '('
#1137: FILE: linux/drivers/media/dvb/frontends/cx22702.c:273:
+                     dprintk ("%s: invalid hierarchy\n",__func__);

ERROR: need space after that ',' (ctx:VxV)
#1137: FILE: linux/drivers/media/dvb/frontends/cx22702.c:273:
+                     dprintk ("%s: invalid hierarchy\n",__func__);
                                                        ^

WARNING: no space between function name and open parenthesis '('
#1146: FILE: linux/drivers/media/dvb/frontends/cx22702.c:287:
+                     dprintk ("%s: invalid code_rate_HP\n",__func__);

ERROR: need space after that ',' (ctx:VxV)
#1146: FILE: linux/drivers/media/dvb/frontends/cx22702.c:287:
+                     dprintk ("%s: invalid code_rate_HP\n",__func__);
                                                           ^

WARNING: no space between function name and open parenthesis '('
#1155: FILE: linux/drivers/media/dvb/frontends/cx22702.c:298:
+                     dprintk ("%s: invalid code_rate_LP\n",__func__);

ERROR: need space after that ',' (ctx:VxV)
#1155: FILE: linux/drivers/media/dvb/frontends/cx22702.c:298:
+                     dprintk ("%s: invalid code_rate_LP\n",__func__);
                                                           ^

WARNING: no space between function name and open parenthesis '('
#1164: FILE: linux/drivers/media/dvb/frontends/cx22702.c:310:
+                     dprintk ("%s: invalid guard_interval\n",__func__);

ERROR: need space after that ',' (ctx:VxV)
#1164: FILE: linux/drivers/media/dvb/frontends/cx22702.c:310:
+                     dprintk ("%s: invalid guard_interval\n",__func__);
                                                             ^
WARNING: no space between function name and open parenthesis '('
#1172: FILE: linux/drivers/media/dvb/frontends/cx22702.c:317:
+                     dprintk ("%s: invalid transmission_mode\n",__func__);

ERROR: need space after that ',' (ctx:VxV)
#1172: FILE: linux/drivers/media/dvb/frontends/cx22702.c:317:
+                     dprintk ("%s: invalid transmission_mode\n",__func__);
                                                                ^

ERROR: need space after that ',' (ctx:WxV)
#1181: FILE: linux/drivers/media/dvb/frontends/cx22702.c:363:
+             ,__func__,reg0A,reg23);
              ^

ERROR: need space after that ',' (ctx:VxV)
#1181: FILE: linux/drivers/media/dvb/frontends/cx22702.c:363:
+             ,__func__,reg0A,reg23);
                       ^

ERROR: need space after that ',' (ctx:VxV)
#1181: FILE: linux/drivers/media/dvb/frontends/cx22702.c:363:
+             ,__func__,reg0A,reg23);
                             ^

ERROR: need space after that ',' (ctx:VxV)
#1214: FILE: linux/drivers/media/dvb/frontends/cx24110.c:250:
+     dprintk("cx24110 debug: entering %s(%d)\n",__func__,srate);
                                                ^

ERROR: need space after that ',' (ctx:VxV)
#1214: FILE: linux/drivers/media/dvb/frontends/cx24110.c:250:
+     dprintk("cx24110 debug: entering %s(%d)\n",__func__,srate);
                                                         ^

WARNING: line over 80 characters
#1331: FILE: linux/drivers/media/dvb/frontends/lgdt330x.c:92:
+                     printk(KERN_WARNING "lgdt330x: %s error (addr
%02x <- %02x, err = %i)\n", __func__, msg.buf[0], msg.buf[1], err);

WARNING: line over 80 characters
#1340: FILE: linux/drivers/media/dvb/frontends/lgdt330x.c:121:
+             printk(KERN_WARNING "lgdt330x: %s: addr 0x%02x select
0x%02x error (ret == %i)\n", __func__, state->config->demod_address,
reg, ret);

WARNING: line over 80 characters
#1385: FILE: linux/drivers/media/dvb/frontends/lgdt330x.c:385:
+                     printk(KERN_WARNING "lgdt330x: %s: Modulation
type(%d) UNSUPPORTED\n", __func__, param->u.vsb.modulation);

WARNING: line over 80 characters
#1403: FILE: linux/drivers/media/dvb/frontends/lgdt330x.c:449:
+     dprintk("%s: TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS
= 0x%02x\n", __func__, buf[0], buf[1], buf[2]);

WARNING: line over 80 characters
#1421: FILE: linux/drivers/media/dvb/frontends/lgdt330x.c:484:
+             printk(KERN_WARNING "lgdt330x: %s: Modulation set to
unsupported value\n", __func__);

WARNING: line over 80 characters
#1448: FILE: linux/drivers/media/dvb/frontends/lgdt330x.c:543:
+             printk(KERN_WARNING "lgdt330x: %s: Modulation set to
unsupported value\n", __func__);

ERROR: need space after that ',' (ctx:VxV)
#1491: FILE: linux/drivers/media/dvb/frontends/lgdt330x.c:753:
+     dprintk("%s: ERROR\n",__func__);
                           ^

ERROR: need space after that ',' (ctx:VxV)
#1698: FILE: linux/drivers/media/dvb/frontends/mt352.c:525:
+     dprintk("%s: hello\n",__func__);
                           ^

WARNING: printk() should include KERN_ facility level
#1966: FILE: linux/drivers/media/dvb/frontends/s5h1409.c:335:
+             printk("%s: readreg error (ret == %i)\n", __func__, ret);

WARNING: line over 80 characters
#2182: FILE: linux/drivers/media/dvb/frontends/s5h1420.c:66:
+             dprintk ("%s: writereg error (err == %i, reg == 0x%02x,
data == 0x%02x)\n", __func__, err, reg, data);

WARNING: no space between function name and open parenthesis '('
#2182: FILE: linux/drivers/media/dvb/frontends/s5h1420.c:66:
+             dprintk ("%s: writereg error (err == %i, reg == 0x%02x,
data == 0x%02x)\n", __func__, err, reg, data);

WARNING: line over 80 characters
#2206: FILE: linux/drivers/media/dvb/frontends/sp8870.c:73:
+             dprintk ("%s: writereg error (err == %i, reg == 0x%02x,
data == 0x%02x)\n", __func__, err, reg, data);

WARNING: no space between function name and open parenthesis '('
#2206: FILE: linux/drivers/media/dvb/frontends/sp8870.c:73:
+             dprintk ("%s: writereg error (err == %i, reg == 0x%02x,
data == 0x%02x)\n", __func__, err, reg, data);

WARNING: no space between function name and open parenthesis '('
#2224: FILE: linux/drivers/media/dvb/frontends/sp8870.c:107:
+     dprintk ("%s: ...\n", __func__);

WARNING: printk() should include KERN_ facility level
#2234: FILE: linux/drivers/media/dvb/frontends/sp8870.c:134:
+                     printk("%s: firmware upload failed!\n", __func__);

WARNING: no space between function name and open parenthesis '('
#2235: FILE: linux/drivers/media/dvb/frontends/sp8870.c:135:
+                     printk ("%s: i2c error (err == %i)\n", __func__, err);

WARNING: no space between function name and open parenthesis '('
#2242: FILE: linux/drivers/media/dvb/frontends/sp8870.c:141:
+     dprintk ("%s: done!\n", __func__);

WARNING: no space between function name and open parenthesis '('
#2251: FILE: linux/drivers/media/dvb/frontends/sp8870.c:313:
+     dprintk ("%s\n", __func__);

WARNING: printk() should include KERN_ facility level
#2278: FILE: linux/drivers/media/dvb/frontends/sp8870.c:500:
+             printk("%s: firmware crash!!!!!!\n", __func__);

WARNING: printk() should include KERN_ facility level
#2287: FILE: linux/drivers/media/dvb/frontends/sp8870.c:507:
+                             printk("%s: firmware lockup!!!\n", __func__);

WARNING: line over 80 characters
#2288: FILE: linux/drivers/media/dvb/frontends/sp8870.c:508:
+                             printk("%s: recovered after %i
trial(s))\n",  __func__, trials - 1);

WARNING: printk() should include KERN_ facility level
#2288: FILE: linux/drivers/media/dvb/frontends/sp8870.c:508:
+                             printk("%s: recovered after %i
trial(s))\n",  __func__, trials - 1);
WARNING: line over 80 characters
#2294: FILE: linux/drivers/media/dvb/frontends/sp8870.c:513:
+             printk("%s: switches = %i lockups = %i\n", __func__,
switches, lockups);

WARNING: printk() should include KERN_ facility level
#2294: FILE: linux/drivers/media/dvb/frontends/sp8870.c:513:
+             printk("%s: switches = %i lockups = %i\n", __func__,
switches, lockups);

WARNING: printk() should include KERN_ facility level
#2336: FILE: linux/drivers/media/dvb/frontends/sp887x.c:85:
+             printk("%s: readreg error (ret == %i)\n", __func__, ret);

WARNING: no space between function name and open parenthesis '('
#2381: FILE: linux/drivers/media/dvb/frontends/sp887x.c:158:
+     printk ("%s: firmware upload... ", __func__);

WARNING: no space between function name and open parenthesis '('
#2390: FILE: linux/drivers/media/dvb/frontends/sp887x.c:184:
+                     printk ("%s: i2c error (err == %i)\n", __func__, err);

WARNING: line over 80 characters
#2423: FILE: linux/drivers/media/dvb/frontends/stv0297.c:78:
+                     dprintk("%s: readreg error (reg == 0x%02x, ret
== %i)\n", __func__, reg, ret);

WARNING: line over 80 characters
#2428: FILE: linux/drivers/media/dvb/frontends/stv0297.c:82:
+                     dprintk("%s: readreg error (reg == 0x%02x, ret
== %i)\n", __func__, reg, ret);

WARNING: line over 80 characters
#2434: FILE: linux/drivers/media/dvb/frontends/stv0297.c:87:
+                     dprintk("%s: readreg error (reg == 0x%02x, ret
== %i)\n", __func__, reg, ret);

WARNING: line over 80 characters
#2443: FILE: linux/drivers/media/dvb/frontends/stv0297.c:118:
+                     dprintk("%s: readreg error (reg == 0x%02x, ret
== %i)\n", __func__, reg1, ret);

WARNING: line over 80 characters
#2448: FILE: linux/drivers/media/dvb/frontends/stv0297.c:122:
+                     dprintk("%s: readreg error (reg == 0x%02x, ret
== %i)\n", __func__, reg1, ret);

WARNING: line over 80 characters
#2454: FILE: linux/drivers/media/dvb/frontends/stv0297.c:127:
+                     dprintk("%s: readreg error (reg == 0x%02x, ret
== %i)\n", __func__, reg1, ret);

WARNING: no space between function name and open parenthesis '('
#2504: FILE: linux/drivers/media/dvb/frontends/stv0299.c:137:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#2513: FILE: linux/drivers/media/dvb/frontends/stv0299.c:177:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#2522: FILE: linux/drivers/media/dvb/frontends/stv0299.c:192:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#2527: FILE: linux/drivers/media/dvb/frontends/stv0299.c:196:
+                     dprintk ("%s: timeout!!\n", __func__);

WARNING: no space between function name and open parenthesis '('
#2536: FILE: linux/drivers/media/dvb/frontends/stv0299.c:209:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#2541: FILE: linux/drivers/media/dvb/frontends/stv0299.c:213:
+                     dprintk ("%s: timeout!!\n", __func__);

WARNING: no space between function name and open parenthesis '('
#2550: FILE: linux/drivers/media/dvb/frontends/stv0299.c:248:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#2560: FILE: linux/drivers/media/dvb/frontends/stv0299.c:260:
+     dprintk ("%s : srate = %i\n", __func__, srate);

WARNING: no space between function name and open parenthesis '('
#2561: FILE: linux/drivers/media/dvb/frontends/stv0299.c:261:
+     dprintk ("%s : ofset = %i\n", __func__, offset);

WARNING: no space between function name and open parenthesis '('
#2570: FILE: linux/drivers/media/dvb/frontends/stv0299.c:279:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#2579: FILE: linux/drivers/media/dvb/frontends/stv0299.c:308:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#2597: FILE: linux/drivers/media/dvb/frontends/stv0299.c:411:
+             printk ("%s switch command: 0x%04lx\n",__func__, cmd);

ERROR: need space after that ',' (ctx:VxV)
#2597: FILE: linux/drivers/media/dvb/frontends/stv0299.c:411:
+             printk ("%s switch command: 0x%04lx\n",__func__, cmd);
                                                    ^

WARNING: no space between function name and open parenthesis '('
#2615: FILE: linux/drivers/media/dvb/frontends/stv0299.c:464:
+     dprintk ("%s : FE_READ_STATUS : VSTATUS: 0x%02x\n", __func__, sync);

WARNING: line over 80 characters
#2624: FILE: linux/drivers/media/dvb/frontends/stv0299.c:502:
+     dprintk ("%s : FE_READ_SIGNAL_STRENGTH : AGC2I: 0x%02x%02x,
signal=0x%04x\n", __func__,

WARNING: no space between function name and open parenthesis '('
#2624: FILE: linux/drivers/media/dvb/frontends/stv0299.c:502:
+     dprintk ("%s : FE_READ_SIGNAL_STRENGTH : AGC2I: 0x%02x%02x,
signal=0x%04x\n", __func__,

WARNING: no space between function name and open parenthesis '('
#2633: FILE: linux/drivers/media/dvb/frontends/stv0299.c:539:
+     dprintk ("%s : FE_SET_FRONTEND\n", __func__);

WARNING: no space between function name and open parenthesis '('
#2997: FILE: linux/drivers/media/dvb/frontends/tda10086.c:112:
+     dprintk ("%s\n", __func__);

WARNING: line over 80 characters
#3006: FILE: linux/drivers/media/dvb/frontends/tda10086.c:177:
+                     printk("%s: diseqc queue not ready, command may
be lost.\n", __func__);

WARNING: printk() should include KERN_ facility level
#3006: FILE: linux/drivers/media/dvb/frontends/tda10086.c:177:
+                     printk("%s: diseqc queue not ready, command may
be lost.\n", __func__);

WARNING: no space between function name and open parenthesis '('
#3015: FILE: linux/drivers/media/dvb/frontends/tda10086.c:189:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#3024: FILE: linux/drivers/media/dvb/frontends/tda10086.c:215:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#3033: FILE: linux/drivers/media/dvb/frontends/tda10086.c:243:
+     dprintk ("%s\n", __func__);

WARNING: line over 80 characters
#3042: FILE: linux/drivers/media/dvb/frontends/tda10086.c:270:
+     dprintk ("%s %i %i\n", __func__, fe_params->inversion,
state->config->invert);

WARNING: no space between function name and open parenthesis '('
#3042: FILE: linux/drivers/media/dvb/frontends/tda10086.c:270:
+     dprintk ("%s %i %i\n", __func__, fe_params->inversion,
state->config->invert);

WARNING: no space between function name and open parenthesis '('
#3051: FILE: linux/drivers/media/dvb/frontends/tda10086.c:304:
+     dprintk ("%s %i\n", __func__, symbol_rate);

WARNING: no space between function name and open parenthesis '('
#3060: FILE: linux/drivers/media/dvb/frontends/tda10086.c:370:
+     dprintk ("%s %i\n", __func__, fe_params->u.qpsk.fec_inner);

WARNING: no space between function name and open parenthesis '('
#3069: FILE: linux/drivers/media/dvb/frontends/tda10086.c:416:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#3078: FILE: linux/drivers/media/dvb/frontends/tda10086.c:463:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#3087: FILE: linux/drivers/media/dvb/frontends/tda10086.c:554:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#3096: FILE: linux/drivers/media/dvb/frontends/tda10086.c:583:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#3105: FILE: linux/drivers/media/dvb/frontends/tda10086.c:596:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#3114: FILE: linux/drivers/media/dvb/frontends/tda10086.c:608:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#3123: FILE: linux/drivers/media/dvb/frontends/tda10086.c:624:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#3132: FILE: linux/drivers/media/dvb/frontends/tda10086.c:639:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#3141: FILE: linux/drivers/media/dvb/frontends/tda10086.c:650:
+     dprintk ("%s\n", __func__);

WARNING: no space between function name and open parenthesis '('
#3150: FILE: linux/drivers/media/dvb/frontends/tda10086.c:741:
+     dprintk ("%s\n", __func__);

WARNING: printk() should include KERN_ facility level
#3303: FILE: linux/drivers/media/dvb/frontends/tua6100.c:62:
+             printk("%s: i2c error\n", __func__);

WARNING: line over 80 characters
#3327: FILE: linux/drivers/media/dvb/frontends/ves1820.c:69:
+                     "val == 0x%02x, ret == %i)\n", __func__, reg, data, ret);

WARNING: line over 80 characters
#3360: FILE: linux/drivers/media/dvb/frontends/ves1x93.c:101:
+             dprintk ("%s: writereg error (err == %i, reg == 0x%02x,
data == 0x%02x)\n", __func__, err, reg, data);

WARNING: no space between function name and open parenthesis '('
#3360: FILE: linux/drivers/media/dvb/frontends/ves1x93.c:101:
+             dprintk ("%s: writereg error (err == %i, reg == 0x%02x,
data == 0x%02x)\n", __func__, err, reg, data);

WARNING: line over 80 characters
#3648: FILE: linux/drivers/media/dvb/ttpci/av7110.c:362:
+             printk(KERN_ERR "%s: saa7146_wait_for_debi_done timed
out\n", __func__);

WARNING: line over 80 characters
#3657: FILE: linux/drivers/media/dvb/ttpci/av7110.c:500:
+             printk(KERN_ERR "%s: saa7146_wait_for_debi_done timed
out\n", __func__);

WARNING: line over 80 characters
#3705: FILE: linux/drivers/media/dvb/ttpci/av7110.h:47:
+         do { if ((av7110_debug & level)) { printk("dvb-ttpci: %s():
", __func__); printk(args); } } while (0)

WARNING: printk() should include KERN_ facility level
#3717: FILE: linux/drivers/media/dvb/ttpci/av7110_hw.c:56:
+             printk("%s: invalid count %d\n", __func__, count);

WARNING: printk() should include KERN_ facility level
#3722: FILE: linux/drivers/media/dvb/ttpci/av7110_hw.c:60:
+             printk("%s: wait_for_debi_done failed\n", __func__);

WARNING: printk() should include KERN_ facility level
#3731: FILE: linux/drivers/media/dvb/ttpci/av7110_hw.c:79:
+             printk("%s: invalid count %d\n", __func__, count);

WARNING: printk() should include KERN_ facility level
#3736: FILE: linux/drivers/media/dvb/ttpci/av7110_hw.c:83:
+             printk("%s: wait_for_debi_done 1 failed\n", __func__);

WARNING: printk() should include KERN_ facility level
#3745: FILE: linux/drivers/media/dvb/ttpci/av7110_hw.c:94:
+             printk("%s: wait_for_debi_done #2 failed\n", __func__);

WARNING: line over 80 characters
#3763: FILE: linux/drivers/media/dvb/ttpci/av7110_hw.c:365:
+                     printk(KERN_ERR "dvb-ttpci: %s(): timeout
waiting for COMMAND idle\n", __func__);

WARNING: line over 80 characters
#3772: FILE: linux/drivers/media/dvb/ttpci/av7110_hw.c:382:
+                     printk(KERN_ERR "dvb-ttpci: %s(): timeout
waiting for HANDSHAKE_REG\n", __func__);

WARNING: line over 80 characters
#3830: FILE: linux/drivers/media/dvb/ttpci/av7110_hw.c:578:
+                     printk(KERN_ERR "%s: timeout waiting for COMMAND
to complete\n", __func__);

WARNING: line over 80 characters
#3839: FILE: linux/drivers/media/dvb/ttpci/av7110_hw.c:594:
+                     printk(KERN_ERR "%s: timeout waiting for
HANDSHAKE_REG\n", __func__);

WARNING: printk() should include KERN_ facility level
#3893: FILE: linux/drivers/media/dvb/ttpci/av7110_ir.c:136:
+             printk("%s invalid protocol %x\n", __func__, ir->protocol);

WARNING: printk() should include KERN_ facility level
#3944: FILE: linux/drivers/media/dvb/ttpci/budget-ci.c:1134:
+                             printk("%s: No LNBP21 found!\n", __func__);

WARNING: line over 80 characters
#3956: FILE: linux/drivers/media/dvb/ttpci/budget-core.c:226:
+                     budget->dev->name, __func__,
budget->buffer_warnings, count);

WARNING: printk() should include KERN_ facility level
#3968: FILE: linux/drivers/media/dvb/ttpci/budget.c:441:
+                             printk("%s: No LNBP21 found!\n", __func__);

WARNING: printk() should include KERN_ facility level
#3977: FILE: linux/drivers/media/dvb/ttpci/budget.c:457:
+                             printk("%s: No tda826x found!\n", __func__);

WARNING: printk() should include KERN_ facility level
#3980: FILE: linux/drivers/media/dvb/ttpci/budget.c:459:
+                             printk("%s: No LNBP21 found!\n", __func__);

WARNING: line over 80 characters
#3997: FILE: linux/drivers/media/dvb/ttpci/budget.h:29:
+         do { if ((budget_debug & level)) { printk("%s: %s():
",__stringify(KBUILD_MODNAME), __func__); printk(args); } } while (0)

ERROR: need space after that ',' (ctx:VxV)
#3997: FILE: linux/drivers/media/dvb/ttpci/budget.h:29:
+         do { if ((budget_debug & level)) { printk("%s: %s():
",__stringify(KBUILD_MODNAME), __func__); printk(args); } } while (0)
                                                                ^

WARNING: line over 80 characters
#4001: FILE: linux/drivers/media/dvb/ttpci/budget.h:32:
+         do { if ((budget_debug & level)) { printk("%s: %s(): ",
KBUILD_MODNAME, __func__); printk(args); } } while (0)

WARNING: printk() should include KERN_ facility level
#4040: FILE: linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c:179:
+             printk("%s: failed, receive error %d\n", __func__,

WARNING: printk() should include KERN_ facility level
#4094: FILE: linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c:464:
+     printk("%s: dsp-version: %c%c%c\n", __func__,

WARNING: printk() should include KERN_ facility level
#4148: FILE: linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c:624:
+                     printk("%s: too much work\n", __func__);

WARNING: printk() should include KERN_ facility level
#4184: FILE: linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c:848:
+             printk("%s: iso xfer already running!\n", __func__);

ERROR: need space after that ',' (ctx:VxV)
#4228: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:239:
+                                     __func__,urb->status);
                                              ^

WARNING: printk() should include KERN_ facility level
#4264: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:294:
+             printk("%s: Failed to lock usb mutex.\n", __func__);

WARNING: printk() should include KERN_ facility level
#4325: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:437:
+             printk("%s: packet too short - discarding\n", __func__);

WARNING: printk() should include KERN_ facility level
#4331: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:442:
+             printk("%s: packet too long - discarding\n", __func__);

WARNING: printk() should include KERN_ facility level
#4340: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:525:
+             printk("%s: unknown PVA type: %02x.\n", __func__,

WARNING: printk() should include KERN_ facility level
#4349: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:564:
+             printk("%s: odd sized packet - discarding\n", __func__);

WARNING: printk() should include KERN_ facility level
#4358: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:572:
+             printk("%s: checksum failed - discarding\n", __func__);

WARNING: printk() should include KERN_ facility level
#4493: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:1236:
+             printk("%s: usb_submit_urb failed\n",__func__);

ERROR: need space after that ',' (ctx:VxV)
#4493: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:1236:
+             printk("%s: usb_submit_urb failed\n",__func__);
                                                  ^

WARNING: printk() should include KERN_ facility level
#4585: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:1476:
+             printk("%s: dvb_dmx_init failed: error %d\n", __func__,

WARNING: printk() should include KERN_ facility level
#4603: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:1502:
+             printk("%s: dvb_dmx_init failed: error %d\n", __func__,

WARNING: printk() should include KERN_ facility level
#4612: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:1514:
+             printk("%s: dvb_dmx_init failed: error %d\n", __func__,

WARNING: printk() should include KERN_ facility level
#4654: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:1639:
+             printk("%s: couldn't allocate memory.\n", __func__);

WARNING: printk() should include KERN_ facility level
#4672: FILE: linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c:1771:
+             printk("%s: initialisation failed: error %d.\n", __func__,

WARNING: line over 80 characters
#4705: FILE: linux/drivers/media/video/cpia.h:426:
+#define LOG(fmt,args...) ALOG(KERN_INFO __FILE__ ":%s(%d):" fmt,
__func__ , __LINE__ , ##args)

ERROR: need space after that ',' (ctx:VxV)
#4705: FILE: linux/drivers/media/video/cpia.h:426:
+#define LOG(fmt,args...) ALOG(KERN_INFO __FILE__ ":%s(%d):" fmt,
__func__ , __LINE__ , ##args)
                ^

WARNING: line over 80 characters
#4710: FILE: linux/drivers/media/video/cpia.h:430:
+#define DBG(fmt,args...) ADBG(KERN_DEBUG __FILE__" (%ld):%s(%d):"
fmt, __func__, __LINE__ , ##args)

ERROR: need space after that ',' (ctx:VxV)
#4710: FILE: linux/drivers/media/video/cpia.h:430:
+#define DBG(fmt,args...) ADBG(KERN_DEBUG __FILE__" (%ld):%s(%d):"
fmt, __func__, __LINE__ , ##args)
                ^

ERROR: need space after that ',' (ctx:VxV)
#4722: FILE: linux/drivers/media/video/cpia2/cpia2_core.c:573:
+             LOG("%s: invalid request mode\n",__func__);
                                              ^

ERROR: need space after that ',' (ctx:VxV)
#4731: FILE: linux/drivers/media/video/cpia2/cpia2_core.c:955:
+             LOG("%s: Invalid sensor flag value 0x%0X\n",__func__,
                                                         ^

ERROR: need space after that ',' (ctx:VxV)
#4740: FILE: linux/drivers/media/video/cpia2/cpia2_core.c:2359:
+             ERR("%s: buffer NULL\n",__func__);
                                     ^

ERROR: need space after that ',' (ctx:VxV)
#4746: FILE: linux/drivers/media/video/cpia2/cpia2_core.c:2364:
+             ERR("%s: Internal error, camera_data NULL!\n",__func__);
                                                           ^

ERROR: need space after that ',' (ctx:VxV)
#4755: FILE: linux/drivers/media/video/cpia2/cpia2_core.c:2373:
+             LOG("%s: camera removed\n",__func__);
                                        ^

ERROR: need space after that ',' (ctx:VxV)
#4764: FILE: linux/drivers/media/video/cpia2/cpia2_core.c:2437:
+             ERR("%s: Internal error, camera_data not found!\n",__func__);
                                                                ^

ERROR: no space before that close parenthesis ')'
#5019: FILE: linux/drivers/media/video/cx23885/cx23885-core.c:1062:
+             dprintk(1, "%s() enabling TS int's and DMA\n", __func__ );

ERROR: need space after that ',' (ctx:VxV)
#5080: FILE: linux/drivers/media/video/cx23885/cx23885-core.c:1261:
+     dprintk(1, "%s()\n",__func__);
                         ^

WARNING: printk() should include KERN_ facility level
#5123: FILE: linux/drivers/media/video/cx23885/cx23885-dvb.c:361:
+             printk("%s() dvb_register failed err = %d\n", __func__, err);

ERROR: do not use C99 // comments
#5447: FILE: linux/drivers/media/video/cx88/cx88-alsa.c:556:
+//   dprintk(2, "%s - count %d (+%u), period %d, frame %lu\n", __func__,

ERROR: need space after that ',' (ctx:VxV)
#5459: FILE: linux/drivers/media/video/cx88/cx88-blackbird.c:322:
+     dprintk(1,"%s: 0x%X\n", __func__, command);
               ^

ERROR: no space after that open parenthesis '('
#5468: FILE: linux/drivers/media/video/cx88/cx88-blackbird.c:1084:
+     dprintk( 1, "%s\n", __func__);

WARNING: line over 80 characters
#5477: FILE: linux/drivers/media/video/cx88/cx88-blackbird.c:1094:
+                     dprintk(1,"%s: Unable to acquire hardware,
%d\n", __func__, err);

ERROR: need space after that ',' (ctx:VxV)
#5477: FILE: linux/drivers/media/video/cx88/cx88-blackbird.c:1094:
+                     dprintk(1,"%s: Unable to acquire hardware,
%d\n", __func__, err);
                               ^

ERROR: no space after that open parenthesis '('
#5486: FILE: linux/drivers/media/video/cx88/cx88-blackbird.c:1316:
+     dprintk( 1, "%s\n", __func__);

WARNING: printk() should include KERN_ facility level
#5498: FILE: linux/drivers/media/video/cx88/cx88-core.c:578:
+             printk("%s: %d buffers handled (should be 1)\n",__func__,bc);

ERROR: need space after that ',' (ctx:VxV)
#5498: FILE: linux/drivers/media/video/cx88/cx88-core.c:578:
+             printk("%s: %d buffers handled (should be 1)\n",__func__,bc);
                                                             ^

ERROR: need space after that ',' (ctx:VxV)
#5498: FILE: linux/drivers/media/video/cx88/cx88-core.c:578:
+             printk("%s: %d buffers handled (should be 1)\n",__func__,bc);
                                                                      ^

ERROR: need space after that ',' (ctx:VxV)
#5507: FILE: linux/drivers/media/video/cx88/cx88-core.c:607:
+     dprintk(1,"%s\n",__func__);
               ^

ERROR: need space after that ',' (ctx:VxV)
#5507: FILE: linux/drivers/media/video/cx88/cx88-core.c:607:
+     dprintk(1,"%s\n",__func__);
                      ^

ERROR: no space after that open parenthesis '('
#5550: FILE: linux/drivers/media/video/cx88/cx88-dvb.c:882:
+     dprintk( 1, "%s\n", __func__);

ERROR: no space after that open parenthesis '('
#5559: FILE: linux/drivers/media/video/cx88/cx88-dvb.c:905:
+     dprintk( 1, "%s\n", __func__);

ERROR: no space after that open parenthesis '('
#5568: FILE: linux/drivers/media/video/cx88/cx88-dvb.c:926:
+     dprintk( 1, "%s\n", __func__);

WARNING: line over 80 characters
#5580: FILE: linux/drivers/media/video/cx88/cx88-mpeg.c:178:
+             printk( "%s() Failed. Unsupported value in .mpeg
(0x%08x)\n", __func__,

WARNING: printk() should include KERN_ facility level
#5580: FILE: linux/drivers/media/video/cx88/cx88-mpeg.c:178:
+             printk( "%s() Failed. Unsupported value in .mpeg
(0x%08x)\n", __func__,

ERROR: no space after that open parenthesis '('
#5580: FILE: linux/drivers/media/video/cx88/cx88-mpeg.c:178:
+             printk( "%s() Failed. Unsupported value in .mpeg
(0x%08x)\n", __func__,

ERROR: need space after that ',' (ctx:VxV)
#5616: FILE: linux/drivers/media/video/cx88/cx88-mpeg.c:383:
+     dprintk(1, "%s\n",__func__);
                       ^

WARNING: line over 80 characters
#5625: FILE: linux/drivers/media/video/cx88/cx88-mpeg.c:686:
+             mpeg_dbg(1,"%s() Post acquire GPIO=%x\n", __func__,
cx_read(MO_GP0_IO));

ERROR: need space after that ',' (ctx:VxV)
#5625: FILE: linux/drivers/media/video/cx88/cx88-mpeg.c:686:
+             mpeg_dbg(1,"%s() Post acquire GPIO=%x\n", __func__,
cx_read(MO_GP0_IO));
                        ^

WARNING: line over 80 characters
#5634: FILE: linux/drivers/media/video/cx88/cx88-mpeg.c:702:
+             mpeg_dbg(1,"%s() Post release GPIO=%x\n", __func__,
cx_read(MO_GP0_IO));

ERROR: need space after that ',' (ctx:VxV)
#5634: FILE: linux/drivers/media/video/cx88/cx88-mpeg.c:702:
+             mpeg_dbg(1,"%s() Post release GPIO=%x\n", __func__,
cx_read(MO_GP0_IO));
                        ^

ERROR: no space after that open parenthesis '('
#5643: FILE: linux/drivers/media/video/cx88/cx88-mpeg.c:876:
+     dprintk( 1, "%s\n", __func__);

ERROR: need space after that ',' (ctx:VxV)
#6039: FILE: linux/drivers/media/video/saa7134/saa7134-empress.c:422:
+     dprintk("%s: %s\n",dev->name,__func__);
                        ^

ERROR: need space after that ',' (ctx:VxV)
#6039: FILE: linux/drivers/media/video/saa7134/saa7134-empress.c:422:
+     dprintk("%s: %s\n",dev->name,__func__);
                                  ^

ERROR: need space after that ',' (ctx:VxV)
#6048: FILE: linux/drivers/media/video/saa7134/saa7134-empress.c:470:
+     dprintk("%s: %s\n",dev->name,__func__);
                        ^

ERROR: need space after that ',' (ctx:VxV)
#6048: FILE: linux/drivers/media/video/saa7134/saa7134-empress.c:470:
+     dprintk("%s: %s\n",dev->name,__func__);
                                  ^

WARNING: line over 80 characters
#6060: FILE: linux/drivers/media/video/se401.c:307:
+             dbg("%s - urb shutting down with status: %d", __func__,
urb->status);

#6064: FILE: linux/drivers/media/video/se401.c:310:
+             dbg("%s - nonzero urb status received: %d", __func__,
urb->status);

WARNING: line over 80 characters
#6241: FILE: linux/drivers/media/video/tda9840.c:40:
+         do { if (debug) { printk("%s: %s()[%d]:
",__stringify(KBUILD_MODNAME), __func__, __LINE__); printk(args); } }
while (0)

ERROR: need space after that ',' (ctx:VxV)
#6241: FILE: linux/drivers/media/video/tda9840.c:40:
+         do { if (debug) { printk("%s: %s()[%d]:
",__stringify(KBUILD_MODNAME), __func__, __LINE__); printk(args); } }
while (0)
                                                   ^

WARNING: line over 80 characters
#6245: FILE: linux/drivers/media/video/tda9840.c:43:
+         do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME,
__func__, __LINE__); printk(args); } } while (0)

WARNING: line over 80 characters
#6311: FILE: linux/drivers/media/video/tea6415c.c:42:
+         do { if (debug) { printk("%s: %s()[%d]:
",__stringify(KBUILD_MODNAME), __func__, __LINE__); printk(args); } }
while (0)

ERROR: need space after that ',' (ctx:VxV)
#6311: FILE: linux/drivers/media/video/tea6415c.c:42:
+         do { if (debug) { printk("%s: %s()[%d]:
",__stringify(KBUILD_MODNAME), __func__, __LINE__); printk(args); } }
while (0)
                                                   ^

WARNING: line over 80 characters
#6315: FILE: linux/drivers/media/video/tea6415c.c:45:
+         do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME,
__func__, __LINE__); printk(args); } } while (0)

WARNING: line over 80 characters
#6327: FILE: linux/drivers/media/video/tea6420.c:42:
+         do { if (debug) { printk("%s: %s()[%d]:
",__stringify(KBUILD_MODNAME), __func__, __LINE__); printk(args); } }
while (0)

ERROR: need space after that ',' (ctx:VxV)
#6327: FILE: linux/drivers/media/video/tea6420.c:42:
+         do { if (debug) { printk("%s: %s()[%d]:
",__stringify(KBUILD_MODNAME), __func__, __LINE__); printk(args); } }
while (0)
                                                   ^

WARNING: line over 80 characters
#6331: FILE: linux/drivers/media/video/tea6420.c:45:
+         do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME,
__func__, __LINE__); printk(args); } } while (0)

WARNING: line over 80 characters
#6508: FILE: linux/drivers/media/video/usbvideo/konicawc.c:67:
+             printk(KERN_DEBUG __FILE__ ":%s(): " format "\n",
__func__ , #arg); \

WARNING: line over 80 characters
#6520: FILE: linux/drivers/media/video/usbvideo/quickcam_messenger.c:54:
+             printk(KERN_DEBUG __FILE__ ":%s(): " format "\n",
__func__ , #arg); \

WARNING: line over 80 characters
#6642: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:791:
+     dbg("%s: Deallocating cams=$%p (%d. cameras)", __func__, cams,
cams->num_cameras);

WARNING: line over 80 characters
#6716: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:1020:
+             info("%s: No video endpoint specified; data pump
disabled.", __func__);

WARNING: line over 80 characters
#6765: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:1123:
+             err("%s: Someone tried to open an already opened
device!", __func__);

WARNING: line over 80 characters
#6783: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:1183:
+                                     info("%s: setupOnOpen callback",
__func__);

WARNING: line over 80 characters
#6791: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:1189:
+                                     info("%s: setupOnOpen callback
successful", __func__);

WARNING: line over 80 characters
#6843: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:1556:
+                     err("%s: No default palette; don't know what to
do!", __func__);

WARNING: line over 80 characters
#6900: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:1793:
+                     err("%s: usb_submit_isoc(%d) ret %d", __func__,
i, errFlag);

WARNING: line over 80 characters
#6906: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:1798:
+             info("%s: streaming=1 video_endp=$%02x", __func__,
uvd->video_endp);

WARNING: line over 80 characters
#6962: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:1979:
+                             info("%s: Camera is not operational
(1)", __func__);

WARNING: line over 80 characters
#6971: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:1988:
+                                     info("%s: Camera is not
operational (2)", __func__);

WARNING: line over 80 characters
#6978: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:1994:
+                                     info("%s: Signal=$%08x",
__func__, signalPending);

WARNING: line over 80 characters
#6985: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:2000:
+                                             info("%s: Forced test
pattern screen", __func__);

WARNING: line over 80 characters
#6991: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:2005:
+                                             info("%s: Interrupted!",
__func__);

WARNING: line over 80 characters
#7000: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:2015:
+                                     err("%s: processData not set", __func__);

WARNING: line over 80 characters
#7006: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:2020:
+                          __func__, frame->frameState, frame->seqRead_Length);

WARNING: line over 80 characters
#7012: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:2025:
+                             err("%s: usbvideo_NewFrame() failed
(%d.)", __func__, ret);

WARNING: line over 80 characters
#7021: FILE: linux/drivers/media/video/usbvideo/usbvideo.c:2057:
+                     info("%s: Entered FrameState_Done_Hold state.", __func__);

ERROR: need space after that ',' (ctx:VxV)
#7057: FILE: linux/drivers/media/video/usbvideo/vicam.c:53:
+#define ADBG(lineno,fmt,args...) printk(fmt, jiffies, __func__, lineno, ##args)
                    ^

ERROR: need space after that ',' (ctx:VxV)
#7057: FILE: linux/drivers/media/video/usbvideo/vicam.c:53:
+#define ADBG(lineno,fmt,args...) printk(fmt, jiffies, __func__, lineno, ##args)
                        ^

ERROR: need space after that ',' (ctx:VxV)
#7081: FILE: linux/drivers/media/video/videobuf-dma-sg.c:256:
+                            "%s: videobuf_map_sg failed\n",__func__);
                                                           ^

ERROR: need space after that ',' (ctx:VxV)
#7090: FILE: linux/drivers/media/video/videobuf-dma-sg.c:479:
+             __func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
                      ^

ERROR: need space after that ',' (ctx:VxV)
#7090: FILE: linux/drivers/media/video/videobuf-dma-sg.c:479:
+             __func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
                         ^

ERROR: need space after that ',' (ctx:VxV)
#7090: FILE: linux/drivers/media/video/videobuf-dma-sg.c:479:
+             __func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
                                           ^

ERROR: need space after that ',' (ctx:VxV)
#7102: FILE: linux/drivers/media/video/videobuf-vmalloc.c:118:
+             __func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
                      ^

ERROR: need space after that ',' (ctx:VxV)
#7102: FILE: linux/drivers/media/video/videobuf-vmalloc.c:118:
+             __func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
                         ^

ERROR: need space after that ',' (ctx:VxV)
#7102: FILE: linux/drivers/media/video/videobuf-vmalloc.c:118:
+             __func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
                                           ^

total: 82 errors, 185 warnings, 6179 lines checked
