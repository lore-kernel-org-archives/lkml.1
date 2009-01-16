Return-Path: <linux-kernel-owner+w=401wt.eu-S934056AbZAPBG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056AbZAPBG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZAPBGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:06:19 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:33347 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754144AbZAPBGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:06:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aIVQFwTWAStbiBMLG39rZAsFP1sw/gqGo9FW8UzK0tBBFw+/OYOhsNs1upkG7R8z09lGCXPcV/EdvI9iAViW/c98Jhik+zHhyXeGNLZHiEtJVLInBfFSJT+GltxKo34sbhpqKGHI7b/Uxahco+Z1zS0EItChUmQSI6+iahLtziY=  ;
X-YMail-OSG: ITeKb.wVM1k8NoxEPwgRbS5y47NPp.d5eAdJ0QmY8AWM7EshiE.KT64cJB7EBmXop0M_6gSPaE54IA50X.nZ33V6U0ax6.AeOIqHzx8EJvqICNq7Ga.jjVM2gllHLO7IszVk7bDfQzENsfxYlBqSH4Bks1prDB_7F8Ao0MGB9n71oxbDkfNVd1ZBcZuk
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.29-rc] regulator: minor cleanup of virtual consumer
Date: Thu, 15 Jan 2009 17:06:15 -0800
User-Agent: KMail/1.9.10
Cc: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
       linux-kernel@vger.kernel.org
References: <200901141316.27584.david-b@pacbell.net> <20090115161022.2b11ed41.akpm@linux-foundation.org>
In-Reply-To: <20090115161022.2b11ed41.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151706.15872.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Andrew Morton wrote:
> > -	else if (strncmp(buf, "standby", strlen("standby")) == 0)
> > +	else if (sysfs_streq(buf, "standby\n") == 0)
> >  		mode = REGULATOR_MODE_STANDBY;
> 
> we don't need the \n's, do we?

No, but ...

That's what saves an extra couple dozen bytes of
memory ... the strings, with newlines, are used
to *write* these sysfs attributes.

- Dave



