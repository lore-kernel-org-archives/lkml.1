Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYDHO3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYDHO3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbYDHO3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:29:31 -0400
Received: from outbound-mail-20.bluehost.com ([69.89.20.235]:39714 "HELO
	outbound-mail-20.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752590AbYDHO3a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:29:30 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas =?iso-8859-1?q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Subject: Re: [PATCH] x86: create array based interface to change page attribute
Date: Tue, 8 Apr 2008 07:27:27 -0700
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <200804071404.28691.jbarnes@virtuousgeek.org> <47FB0EE8.30001@tungstengraphics.com>
In-Reply-To: <47FB0EE8.30001@tungstengraphics.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804080727.27309.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 07, 2008 11:21 pm Thomas Hellström wrote:
> Jesse Barnes wrote:
> > On Monday, April 07, 2008 1:46 pm Thomas Hellström wrote:
> >>> Why would we need to flush at all at unbind-read-bind time?  We should
> >>> be able to leave pages in the WC state even when we unbind them, then
> >>> when we need to bind them back into the GTT they'll be ready, but maybe
> >>> I'm misunderstanding you here...
> >>
> >> We want to make the user-space mapping cache-coherent after unbind
> >> during read, to have any serious read-speed, and the linear kernel map
> >> has to follow, unless it's non-present. Even if it's non present, we
> >> need to flush whatever was written through the user-space mapping from
> >> the cache when rebinding. Having the user-space mapping read-only when
> >> possible will help avoid this.
> >
> > Ah, you actually want to *read* from memory?  Yeah that would be really
> > slow if we left it UC or WC.  But I thought that was really only
> > necessary for relocation, and keithp dealt with that with the "presumed
> > offset" stuff?  Are you seeing other cases where we need to read back
> > frequently?
>
> While keithp's "presumed offset" is really good stuff, we should never
> need to read from device memory during relocations, I think. I was
> thinking of EXA and OpenGL software fallback cases, "download from
> screen" and "readpixels" types of operation, as well as
> pixel-buffer-object map in read mode.

Hm, yeah, anholt was telling me about some of these cases offline too.  This 
is what makes things really difficult...

Jesse
