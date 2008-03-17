Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYCQVHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYCQVHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 17:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYCQVG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 17:06:56 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:35180 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751700AbYCQVGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 17:06:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IKOKMg2uwYNhGDpxmPN529Xv3C1sPnSUif3ecrppsQl+JRYB3lX558AHNqZyIw2F6oX4cVcUiqKSL1DEfnVw82SWbY863evoKBQVQ7KlnElJ52Mj56RhCmvqQyur9u0mRB4X/q8K2sHaCsoKABNlxaPROX/fQ2QNJQd2q3UwxiU=  ;
X-YMail-OSG: gHFm2vIVM1nGkUab7T1wlJCzYi316uHOIDiOapvsKy6lhDRAYOgoMH4tVjA1Tbhda9dZzsq0ZQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
Subject: Re: ehci-hcd affects hda speed
Date: Mon, 17 Mar 2008 13:06:52 -0800
User-Agent: KMail/1.9.6
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       Rene Herman <rene.herman@keyaccess.nl>, linux-kernel@vger.kernel.org
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <alpine.LFD.1.00.0803101303240.4772@nev.ubzr> <alpine.LFD.1.00.0803160054360.23451@nev.ubzr>
In-Reply-To: <alpine.LFD.1.00.0803160054360.23451@nev.ubzr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171406.53241.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008, Lev A. Melnikovsky wrote:
>  	Particularly, what does "MAC turn around 
> time" stand for with respect to EHCI? I would appreciate some reference, 
> thanks.

Blame VIA for that one.  Notice how their descriptions of the
fields in that register don't even mention a MAC.  :)

But the relevant bit is the "sleep time" and that's described
in the EHCI specification.  It basically means how long it waits,
after noticing a "no work for me" async schedule ring, before
scanning that schedule again.  It seems your system had that
set to just 1 usec, meaning it would hardly give anything else
a chance to get onto the PCI bus.  That's probably why the EHCI
spec uses a value of 10 usec:  basic fairness.

- Dave


