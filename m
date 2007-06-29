Return-Path: <linux-kernel-owner+w=401wt.eu-S1765735AbXF2M7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765735AbXF2M7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbXF2M7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:59:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56359 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbXF2M7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:59:31 -0400
Subject: Re: Linux Kernel include files
From: David Woodhouse <dwmw2@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>,
       arjan@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       schilling@fokus.fraunhofer.de, Ulrich Drepper <drepper@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0706281546340.22579@fbirervta.pbzchgretzou.qr>
References: <46826d13.44vmeDzVCWEJhtNJ%Joerg.Schilling@fokus.fraunhofer.de>
	 <20070627171812.GA31705@uranus.ravnborg.org>
	 <Pine.LNX.4.64.0706281546340.22579@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Fri, 29 Jun 2007 13:59:26 +0100
Message-Id: <1183121966.1170.324.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 15:49 +0200, Jan Engelhardt wrote:
> I'll have to chime in here.
> Test program:
> #include <sys/socket.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <arpa/inet.h>
> #include <netinet/in.h>
> #include <errno.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <linux/in.h> /* get IP_FREEBIND */
> 
> Creates a lot of error messages.
> (Lots of redefinitions.)
> 
> $ rpm -q linux-kernel-headers glibc
> linux-kernel-headers-2.6.21-7
> glibc-2.6-5
> (suse 10.3 factory)
> 
> So looks like there's still something to do.

Hm, yes. But what? Is it reasonable for people to include <linux/in.h>
and <netinet/in.h> at the same time? 

It's suboptimal that they have to include <linux/in.h> for certain
definitions, but that file also provides conflicting definitions of
stuff which exists elsewhere.

Should we split <linux/in.h> into two parts?

-- 
dwmw2

