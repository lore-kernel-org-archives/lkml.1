Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbZDBS5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbZDBS5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbZDBS4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:56:50 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:38695 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754784AbZDBS4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:56:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=54LS5DAcsYUmi/QDfrryaOMjkeiGQq/sEwa1JkWYpAhcng5sBXFAvpkhk8vVF1GeN6BZdKJ0CaI9ktQPrkT55G6my8BHQbicKq66UDLIf42avJ8d/dHXi+/lmyh8CmGMsWLUGiwut2yKJotPUqMNJ7O4WpIYoHB5eG9s2O4zUVY=  ;
X-YMail-OSG: rhetpdYVM1kyOLT4BsuWafQs78tk.GEjIfBBuud25MqfW9zyWRoTqRaBPMj1Jp8Thgseqz7LzZVnCCi2YwU4DqJMzzqtpMER7QY9QULy4RxD3gaHcPBXL.b8vsYzrXo6pNIgKrgMEzlWYq87hvSuRC.rNz6x_oPxjrmTpC46Z8t.0Sui96L.1GtnCOYGfIkd9hN08VpKqHJngNlm947xRf4Am_HmjCUNeN14bpLEZTQgPiBlDu.PufrJpZpIoPmqX4N9Emv2Ej.imfqdbenYmZXQZ5hTSU.SrQ6luj9gtHTCInBZR8U5
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Ext4 and the "30 second window of death"
Date: Fri, 3 Apr 2009 05:56:40 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903291224.21380.info@gnebu.es> <200904030535.00335.nickpiggin@yahoo.com.au> <20090402183834.GB4773@srcf.ucam.org>
In-Reply-To: <20090402183834.GB4773@srcf.ucam.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904030556.41270.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 05:38:34 Matthew Garrett wrote:
> On Fri, Apr 03, 2009 at 05:34:59AM +1100, Nick Piggin wrote:
> 
> > Shouldn't applications have a mode to avoid spinning up the disk if it is
> > so important?
> 
> They do. It's called "Don't use fsync() unless your data needs to be on 
> disk". I'm not sure why you'd ever want an application to be in anything 
> but this mode.
> 

Well you might decide you are willing to sacrifice timely storage of
logs, or reducing backups in your editor or something. But obviously
the kernel can't decide which of those fsyncs is safe to omit (or
turn into a barrier) while staying within the advertised semantics of
the app. Application obviously can.

