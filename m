Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbXFOJ26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbXFOJ26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXFOJ2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:28:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:51578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbXFOJ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:28:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: drm: fix radeon setparam on 32/64 bit systems.
Date: Fri, 15 Jun 2007 11:28:39 +0200
User-Agent: KMail/1.9.6
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <1181897060.25228.323.camel@pmac.infradead.org> <1181897905.26853.66.camel@localhost.localdomain>
In-Reply-To: <1181897905.26853.66.camel@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151128.39566.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18KNxIRnHTBpO5rGDF7FcgfUtdmgpYqnKNI9fc
 n1WNGNBDfeocp5uTSKy57UwDAVJBjsXlKG1cPjVhSpoQo4w6Oe
 0rlwgFJ/8sqA3ojI3On0w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007, Benjamin Herrenschmidt wrote:
> 
> > Only on i386. I think you just broke ppc32-on-ppc64.
> 
> Indeed... I'm pretty sure the 64 bits quantity will be naturally aligned
> on ppc32 (and possibly others).
> 

Ok, I'll bite. I've been telling people for ages what the right solution
for this is, but apparently sometimes you need to do it yourself if you
want to have it done well ;-)

Patch follows to introduce compat_u64. Please redefine your data
structure as

typedef struct drm_radeon_setparam32 {
     int param;
     compat_u64 value;
} drm_radeon_setparam32_t;

	Arnd <><
