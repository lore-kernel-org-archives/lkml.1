Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZGUJlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZGUJlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 05:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZGUJlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 05:41:10 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:29077 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbZGUJlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 05:41:09 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432R98dNzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 8,
X-WSS-ID: 0KN4LJZ-03-ENE-01
Date: Tue, 21 Jul 2009 11:40:44 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Aristeu Rozanski <aris@redhat.com>
CC: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, norsk5@yahoo.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 01/14] amd64_edac: simplify error type bits extractors
Message-ID: <20090721094044.GB32338@aftab>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
 <1248106385-27514-2-git-send-email-borislav.petkov@amd.com>
 <20090720175644.GK8168@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090720175644.GK8168@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Jul 2009 09:40:44.0127 (UTC) FILETIME=[5166D6F0:01CA09E7]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 01:56:44PM -0400, Aristeu Rozanski wrote:
> Hi Borislav,
> > -	/* If this was an 'observed' error, early out */
> > -	if (ec_pp == K8_NBSL_PP_OBS)
> > -		return;		/* We aren't the node involved */
> > +
> > +	/* Bail early out if this was an 'observed' error */
> > +	if (((ec >> 9) & 0x3) == K8_NBSL_PP_OBS)
> > +		return;
> minor thing:
> this patch and others makes me think if it wouldn't be better to have:
> 	#define PP(x)		(((x) >> 9) & 0x3)
> 	#define PP_MSG(x)	pp_msgs[PP(x)]
> and the same for LL, TT, RRRR.

Yep, it seems that way, will fix :).

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

