Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZKWNE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZKWNE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbZKWNE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:04:56 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:52232 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068AbZKWNEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:04:55 -0500
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <2f11576a0911031158r7fabb96fx8073bb4e86f4981e@mail.gmail.com>
References: <1257273488.9427.27.camel@mulgrave.site>
	 <20091103105921.160d5599.akpm@linux-foundation.org>
	 <20091103191233.0c3ba736@lxorguk.ukuu.org.uk>
	 <2f11576a0911031158r7fabb96fx8073bb4e86f4981e@mail.gmail.com>
Content-Type: text/plain
Organization: IBM
Date: Mon, 23 Nov 2009 14:04:59 +0100
Message-Id: <1258981499.11269.6.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have several places in my code where the new __must_check of strstrip
will introduce unnecessary dummy variables to avoid the warnings.

Therefore I would like to have the suggested new strim() or
strstip_tail() function. Any chance to have this upstream soon?

Michael

On Wed, 2009-11-04 at 04:58 +0900, KOSAKI Motohiro wrote:
> 2009/11/4 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> >> static inline void strsrip_tail(char *str)
> >> {
> >>       char *x __used;
> >>       x = strstrip(str);
> >> }
> >
> > Bikeshed time but its cleaner to do
> >
> > static inline __must_check void strstrip(char *str)
> > {
> >        return strim(str);
> > }
> >
> > and make strim() the old strstrip function without the check requirement
> 
> Okey...
> 
> [quick hack and compile check]
> 
> done :)
> sorry for attached file. I'm under poor mail environment now.

