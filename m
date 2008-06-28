Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYF1QA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYF1QA4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 12:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYF1QAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 12:00:45 -0400
Received: from relay2.netbox.cz ([83.240.0.204]:39217 "EHLO relay1.netbox.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751754AbYF1QAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 12:00:18 -0400
Date: Sat, 28 Jun 2008 19:56:37 +0200
From: Zbynek Hrabovsky <hrabosh@t-email.cz>
To: "Nicolas Marot" <nicolas.marot@gmail.com>
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, video4linux-list@redhat.com,
       nicolas <nicolas@niko2.homelinux.org>,
       "Michel Lespinasse" <walken@zoy.org>
Subject: Re: [PATCH][RESEND] New type of DTV2000H TV Card
Message-Id: <20080628195637.6dacc709.hrabosh@t-email.cz>
In-Reply-To: <f4d5b6dd0806201352h4538072fy20f6187f54f81bae@mail.gmail.com>
References: <20080207002224.e26d6bb1.hrabosh@t-email.cz>
	<20080613151843.240a62cb@gaivota>
	<20080620235242.e1e97f18.hrabosh@t-email.cz>
	<f4d5b6dd0806201352h4538072fy20f6187f54f81bae@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Sat__28_Jun_2008_19_56_37_+0200_sh+HMMPsvZqCR3qj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Sat__28_Jun_2008_19_56_37_+0200_sh+HMMPsvZqCR3qj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Hi Nicolas,

so I should install git and run these commands, or .. ? I'm really confuzzled. 

But I had installed GPG and signed my patch, maybe this is what I should have done earlier. My key ID is: 7803B3E1

If you guys want me somethink more to do, write me ... I'll do my best.

Thanx for your time

Zbynek

On Fri, 20 Jun 2008 22:52:02 +0200
"Nicolas Marot" <nicolas.marot@gmail.com> wrote:

> Hi Zbynek,
> 
> I think lines Mauro asks us are some git commands on driver source code
> 
> nicolas
> 
> 
> On Fri, Jun 20, 2008 at 11:52 PM, Zbynek Hrabovsky <hrabosh@t-email.cz>
> wrote:
> 
> > Hi Mauro,
> >
> > thanks for your answer.
> >
> > I've tried to apply the updated patch you've sent me and it is working, but
> > ....
> >
> > ... there is a little problem with this:
> >
> > --- a/linux/drivers/media/video/cx88/cx88-mpeg.c        Tue Jun 10 15:27:29
> > 2008 -0300
> > +++ b/linux/drivers/media/video/cx88/cx88-mpeg.c        Fri Jun 13 15:07:34
> > 2008 -0300
> > @@ -148,6 +148,12 @@
> >                        cx_write(TS_SOP_STAT, 0);
> >                        cx_write(TS_VALERR_CNTRL, 0);
> >                        udelay(100);
> > +                       break;
> > +               case CX88_BOARD_WINFAST_DTV2000H_2:
> > +                       /* switch signal input to antena */
> > +                       cx_write(MO_GP0_IO, 0x00017300);
> > +
> > +                       cx_write(TS_SOP_STAT, 0x00);
> >                        break;
> >                default:
> >                        cx_write(TS_SOP_STAT, 0x00);
> >
> >
> > This piece of code used to switch the input of RF signal to "Air Antenna"
> > mode. When I was writing the patch, this code was executed every time I was
> > tunning DVB-T station. (using Kaffeine, or sth.) But now ( I don't know why
> > ... ) this code is ran only if the station is succesfully tuned ... which is
> > late for switching RF input.
> >
> > So ... all the things about sound in analog TV and video inputs, etc. are
> > working well, but switching between Cable and Air Antenna RF inputs must be
> > done using programs for analog TV ... such as TvTime for example.
> >
> > It would be nice, if this patch (and driver) would be able to switch RF
> > inputs in DVB-T mode somehow. My idea is, to have two DVB-T devices ... one
> > would use Air Antenna input as a source of signal, second the Cable input as
> > source of signal. This will provide us to receive DVB-T from both inputs
> > (BTW ... original Windows driver is not able to do this). The problem is,
> > that I'm not sure if I'm able to do it ... I have very poor idea how all the
> > things around this driver works ...for example which c. file I should focus
> > on. If you would give me a small piece of advise, where to start, I would be
> > pleased.
> >
> > OK, I'm not sure if I understood what you meant by adding sign-off-by and
> > reviewed-by line ... I hope I did what you want me to:
> >
> >
> > So .. thanks for your time,
> > Zbynek
> >
> > Signed-off-by: Zbynek Hrabovsky <hrabosh@t-email.cz>
> >
> > Reviewed-by: Zbynek Hrbaovsky <hrabosh@t-email.cz>
> >
> > diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-cards.c
> > --- a/linux/drivers/media/video/cx88/cx88-cards.c       Tue Jun 10 15:27:29
> > 2008 -0300
> > +++ b/linux/drivers/media/video/cx88/cx88-cards.c       Fri Jun 13 15:07:33
> > 2008 -0300
> > @@ -1284,7 +1284,7 @@
> >        },
> >        [CX88_BOARD_WINFAST_DTV2000H] = {
> >                /* video inputs and radio still in testing */
> > -               .name           = "WinFast DTV2000 H",
> > +               .name           = "WinFast DTV2000 H ver. I (old)",
> >                .tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
> >                .radio_type     = UNSET,
> >                .tuner_addr     = ADDR_UNSET,
> > @@ -1298,6 +1298,45 @@
> >                        .gpio2  = 0x00017304,
> >                        .gpio3  = 0x02000000,
> >                }},
> > +               .mpeg           = CX88_MPEG_DVB,
> > +       },
> > +       [CX88_BOARD_WINFAST_DTV2000H_2] = {
> > +               /* this is just a try */
> > +               .name           = "WinFast DTV2000 H ver. J (new)",
> > +               .tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
> > +               .radio_type     = UNSET,
> > +               .tuner_addr     = ADDR_UNSET,
> > +               .radio_addr     = ADDR_UNSET,
> > +               .tda9887_conf   = TDA9887_PRESENT,
> > +               .input          = { {
> > +                       .type   = CX88_VMUX_TELEVISION,
> > +                       .vmux   = 0,
> > +                       .gpio0  = 0x00017300,
> > +                       .gpio1  = 0x00008207,
> > +                       .gpio2  = 0x00000000,
> > +                       .gpio3  = 0x02000000,
> > +               }, {
> > +                       .type   = CX88_VMUX_TELEVISION,
> > +                       .vmux   = 0,
> > +                       .gpio0  = 0x00018300,
> > +                       .gpio1  = 0x0000f207,
> > +                       .gpio2  = 0x00017304,
> > +                       .gpio3  = 0x02000000,
> > +               }, {
> > +                       .type   = CX88_VMUX_COMPOSITE1,
> > +                       .vmux   = 1,
> > +                       .gpio0  = 0x00018301,
> > +                       .gpio1  = 0x0000f207,
> > +                       .gpio2  = 0x00017304,
> > +                       .gpio3  = 0x02000000,
> > +               }, {
> > +                       .type   = CX88_VMUX_SVIDEO,
> > +                       .vmux   = 2,
> > +                       .gpio0  = 0x00018301,
> > +                       .gpio1  = 0x0000f207,
> > +                       .gpio2  = 0x00017304,
> > +                       .gpio3  = 0x02000000,
> > +               } },
> >                .mpeg           = CX88_MPEG_DVB,
> >        },
> >        [CX88_BOARD_GENIATECH_DVBS] = {
> > @@ -1963,6 +2002,10 @@
> >                .subdevice = 0x665e,
> >                .card      = CX88_BOARD_WINFAST_DTV2000H,
> >        },{
> > +               .subvendor = 0x107d,
> > +               .subdevice = 0x6f2b,
> > +               .card      = CX88_BOARD_WINFAST_DTV2000H_2,
> > +       }, {
> >                .subvendor = 0x18ac,
> >                .subdevice = 0xd800, /* FusionHDTV 3 Gold (original
> > revision) */
> >                .card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,
> > diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-dvb.c
> > --- a/linux/drivers/media/video/cx88/cx88-dvb.c Tue Jun 10 15:27:29 2008
> > -0300
> > +++ b/linux/drivers/media/video/cx88/cx88-dvb.c Fri Jun 13 15:07:34 2008
> > -0300
> > @@ -561,6 +561,7 @@
> >                }
> >                break;
> >        case CX88_BOARD_WINFAST_DTV2000H:
> > +       case CX88_BOARD_WINFAST_DTV2000H_2:
> >        case CX88_BOARD_HAUPPAUGE_HVR1100:
> >        case CX88_BOARD_HAUPPAUGE_HVR1100LP:
> >        case CX88_BOARD_HAUPPAUGE_HVR1300:
> > diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-input.c
> > --- a/linux/drivers/media/video/cx88/cx88-input.c       Tue Jun 10 15:27:29
> > 2008 -0300
> > +++ b/linux/drivers/media/video/cx88/cx88-input.c       Fri Jun 13 15:07:34
> > 2008 -0300
> > @@ -242,6 +242,7 @@
> >                ir->sampling = 1;
> >                break;
> >        case CX88_BOARD_WINFAST_DTV2000H:
> > +       case CX88_BOARD_WINFAST_DTV2000H_2:
> >                ir_codes = ir_codes_winfast;
> >                ir->gpio_addr = MO_GP0_IO;
> >                ir->mask_keycode = 0x8f8;
> >
> > diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88.h
> > --- a/linux/drivers/media/video/cx88/cx88.h     Tue Jun 10 15:27:29 2008
> > -0300
> > +++ b/linux/drivers/media/video/cx88/cx88.h     Fri Jun 13 15:07:34 2008
> > -0300
> > @@ -224,6 +224,7 @@
> >  #define CX88_BOARD_DVICO_FUSIONHDTV_7_GOLD 65
> >  #define CX88_BOARD_PROLINK_PV_8000GT       66
> >  #define CX88_BOARD_KWORLD_ATSC_120         67
> > +#define CX88_BOARD_WINFAST_DTV2000H_2      68
> >
> >  enum cx88_itype {
> >        CX88_VMUX_COMPOSITE1 = 1,
> >
> >
> >
> >
> 

--Multipart=_Sat__28_Jun_2008_19_56_37_+0200_sh+HMMPsvZqCR3qj
Content-Type: text/plain;
 name="DTV2000H.diff.asc"
Content-Disposition: attachment;
 filename="DTV2000H.diff.asc"
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Signed-off-by: Zbynek Hrabovsky <hrabosh@t-email.cz>
Reviewed-by: Zbynek Hrabovsky <hrabosh@t-email.cz>

diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-cards.c
- --- a/linux/drivers/media/video/cx88/cx88-cards.c Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c Fri Jun 13 15:07:33 2008 -0300
@@ -1284,7 +1284,7 @@
},
[CX88_BOARD_WINFAST_DTV2000H] = {
/* video inputs and radio still in testing */
- - .name = "WinFast DTV2000 H",
+ .name = "WinFast DTV2000 H ver. I (old)",
.tuner_type = TUNER_PHILIPS_FMD1216ME_MK3,
.radio_type = UNSET,
.tuner_addr = ADDR_UNSET,
@@ -1298,6 +1298,45 @@
.gpio2 = 0x00017304,
.gpio3 = 0x02000000,
}},
+ .mpeg = CX88_MPEG_DVB,
+ },
+ [CX88_BOARD_WINFAST_DTV2000H_2] = {
+ /* this is just a try */
+ .name = "WinFast DTV2000 H ver. J (new)",
+ .tuner_type = TUNER_PHILIPS_FMD1216ME_MK3,
+ .radio_type = UNSET,
+ .tuner_addr = ADDR_UNSET,
+ .radio_addr = ADDR_UNSET,
+ .tda9887_conf = TDA9887_PRESENT,
+ .input = { {
+ .type = CX88_VMUX_TELEVISION,
+ .vmux = 0,
+ .gpio0 = 0x00017300,
+ .gpio1 = 0x00008207,
+ .gpio2 = 0x00000000,
+ .gpio3 = 0x02000000,
+ }, {
+ .type = CX88_VMUX_TELEVISION,
+ .vmux = 0,
+ .gpio0 = 0x00018300,
+ .gpio1 = 0x0000f207,
+ .gpio2 = 0x00017304,
+ .gpio3 = 0x02000000,
+ }, {
+ .type = CX88_VMUX_COMPOSITE1,
+ .vmux = 1,
+ .gpio0 = 0x00018301,
+ .gpio1 = 0x0000f207,
+ .gpio2 = 0x00017304,
+ .gpio3 = 0x02000000,
+ }, {
+ .type = CX88_VMUX_SVIDEO,
+ .vmux = 2,
+ .gpio0 = 0x00018301,
+ .gpio1 = 0x0000f207,
+ .gpio2 = 0x00017304,
+ .gpio3 = 0x02000000,
+ } },
.mpeg = CX88_MPEG_DVB,
},
[CX88_BOARD_GENIATECH_DVBS] = {
@@ -1963,6 +2002,10 @@
.subdevice = 0x665e,
.card = CX88_BOARD_WINFAST_DTV2000H,
},{
+ .subvendor = 0x107d,
+ .subdevice = 0x6f2b,
+ .card = CX88_BOARD_WINFAST_DTV2000H_2,
+ }, {
.subvendor = 0x18ac,
.subdevice = 0xd800, /* FusionHDTV 3 Gold (original revision) */
.card = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,
diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-dvb.c
- --- a/linux/drivers/media/video/cx88/cx88-dvb.c Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c Fri Jun 13 15:07:34 2008 -0300
@@ -561,6 +561,7 @@
}
break;
case CX88_BOARD_WINFAST_DTV2000H:
+ case CX88_BOARD_WINFAST_DTV2000H_2:
case CX88_BOARD_HAUPPAUGE_HVR1100:
case CX88_BOARD_HAUPPAUGE_HVR1100LP:
case CX88_BOARD_HAUPPAUGE_HVR1300:
diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-input.c
- --- a/linux/drivers/media/video/cx88/cx88-input.c Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-input.c Fri Jun 13 15:07:34 2008 -0300
@@ -242,6 +242,7 @@
ir->sampling = 1;
break;
case CX88_BOARD_WINFAST_DTV2000H:
+ case CX88_BOARD_WINFAST_DTV2000H_2:
ir_codes = ir_codes_winfast;
ir->gpio_addr = MO_GP0_IO;
ir->mask_keycode = 0x8f8;
diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88.h
- --- a/linux/drivers/media/video/cx88/cx88.h Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88.h Fri Jun 13 15:07:34 2008 -0300
@@ -224,6 +224,7 @@
#define CX88_BOARD_DVICO_FUSIONHDTV_7_GOLD 65
#define CX88_BOARD_PROLINK_PV_8000GT 66
#define CX88_BOARD_KWORLD_ATSC_120 67
+#define CX88_BOARD_WINFAST_DTV2000H_2 68

enum cx88_itype {
CX88_VMUX_COMPOSITE1 = 1,
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhmXRgACgkQPedPCXgDs+FAwgCghc3wFwpAmeGkMzGKoJi8HnHz
W5EAn2iybN7vkU3nR7gqJ0k7NBOVSGXD
=O/Qr
-----END PGP SIGNATURE-----

--Multipart=_Sat__28_Jun_2008_19_56_37_+0200_sh+HMMPsvZqCR3qj--
