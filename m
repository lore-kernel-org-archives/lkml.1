Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZKMDls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZKMDls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 22:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbZKMDln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 22:41:43 -0500
Received: from senator.holtmann.net ([87.106.208.187]:60828 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbZKMDlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 22:41:42 -0500
Subject: Re: [patch 0/1] Adding radio type FM
From: Marcel Holtmann <marcel@holtmann.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Janakiram Sistla <janakiram.sistla@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <646765f40911121929p5aa416c3o99f33bd5b5d8c5cb@mail.gmail.com>
References: <4fb5db50911121909h1619e483ga4aa395af8fc1161@mail.gmail.com>
	 <20091113030950.GB4054@tuxdriver.com>
	 <4fb5db50911121925t1a6770ddtbd5f01477470046d@mail.gmail.com>
	 <646765f40911121929p5aa416c3o99f33bd5b5d8c5cb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 04:41:46 +0100
Message-ID: <1258083706.7715.16.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julian,

please stop CCing majordomo@vger.kernel.org since that one is not a
mailing list.

> <janakiram.sistla@gmail.com> wrote:
> > Resending with added comments from John.
> > From 1b1493392faeb6702ff364447b135e481930b397 Mon Sep 17 00:00:00 2001
> > From: Janakiram Sistla <janakiram.sistla@gmail.com>
> > Date: Fri, 13 Nov 2009 08:16:26 +0530
> > Subject: [PATCH 1/1] Adding radio type FM
> >
> > Adding radio type FM in RFKILL_TYPE_.FM also belongs to
> > same class of with both TX/RX capability.
> > Also Added input type for the above same.
> >
> > Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>
> > ---
> >  include/linux/input.h  |    1 +
> >  include/linux/rfkill.h |    1 +
> >  net/rfkill/core.c      |    2 ++
> >  net/rfkill/input.c     |    9 +++++++++
> >  4 files changed, 13 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/input.h b/include/linux/input.h
> > index 0ccfc30..f03ae90 100644
> > --- a/include/linux/input.h
> > +++ b/include/linux/input.h
> > @@ -376,6 +376,7 @@ struct input_absinfo {
> >  #define KEY_DISPLAY_OFF                245     /* display device to off state */
> >
> >  #define KEY_WIMAX              246
> > +#define KEY_FM                 247
> >
> >  /* Range 248 - 255 is reserved for special needs of AT keyboard driver */
> >
> > diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> > index 3392c59..03f5598 100644
> > --- a/include/linux/rfkill.h
> > +++ b/include/linux/rfkill.h
> > @@ -45,6 +45,7 @@ enum rfkill_type {
> >        RFKILL_TYPE_WIMAX,
> >        RFKILL_TYPE_WWAN,
> >        RFKILL_TYPE_GPS,
> > +       RFKILL_TYPE_FM,
> >        NUM_RFKILL_TYPES,
> >  };
> >
> > diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> > index ba2efb9..b8ac206 100644
> > --- a/net/rfkill/core.c
> > +++ b/net/rfkill/core.c
> > @@ -592,6 +592,8 @@ static const char *rfkill_get_type_str(enum
> > rfkill_type type)
> >                return "wwan";
> >        case RFKILL_TYPE_GPS:
> >                return "gps";
> > +       case RRFKILL_TYPE_FM:
> > +               return "fm";
> >        default:
> >                BUG();
> >        }
> > diff --git a/net/rfkill/input.c b/net/rfkill/input.c
> > index a7295ad..f51b16d 100644
> > --- a/net/rfkill/input.c
> > +++ b/net/rfkill/input.c
> > @@ -212,6 +212,9 @@ static void rfkill_event(struct input_handle
> > *handle, unsigned int type,
> >                case KEY_WIMAX:
> >                        rfkill_schedule_toggle(RFKILL_TYPE_WIMAX);
> >                        break;
> > +               case KEY_FM:
> > +                       rfkill_schedule_toggle(RFKILL_TYPE_FM);
> > +                       break;
> >                }
> >        } else if (type == EV_SW && code == SW_RFKILL_ALL)
> >                rfkill_schedule_evsw_rfkillall(data);
> > @@ -290,6 +293,12 @@ static const struct input_device_id rfkill_ids[] = {
> >                .keybit = { [BIT_WORD(KEY_UWB)] = BIT_MASK(KEY_UWB) },
> >        },
> >        {
> > +               .flags = INPUT_DEVICE_ID_MATCH_EVBIT |
> > +                               INPUT_DEVICE_ID_MATCH_KEYBIT,
> > +               .evbit = { BIT_MASK(EV_KEY) },
> > +               .keybit = { [BIT_WORD(KEY_FM)] = BIT_MASK(KEY_UWB) },
> 
> Surely both instances of KEY_UWB should be changed.

which makes it even more clearly that this code path has never been
tested. So lets leave this KEY_FM business out and just submit the
RFKILL additions.

You don't need to emulate a key event to use RFKILL anyway. The new
RFKILL subsystem supports /dev/rfkill and there is the rfkill userspace
utility. Which you wanna send a patch to extend it with FM support.

Regards

Marcel


