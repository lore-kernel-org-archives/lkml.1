Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbZD3Ojq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbZD3Ojq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZD3Ojf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:39:35 -0400
Received: from web50108.mail.re2.yahoo.com ([206.190.38.36]:34173 "HELO
	web50108.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752842AbZD3Oje convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:39:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Z6SzSnEVEJ13F9KJ14J1Qb1vpnLwyjoMo9ljUeF6ZbU9HuvCvJehwxNzLmZuGtgECmSXyyiZU5Ab9Dn6eTr7pAb8l9DojrvLYLosTA2bLNZ3AgNIba9hDVGTViA3ipIfeRBVpm7pqUURd2cS1m1KoDRUcrW8Dew8Zt/sXXZS7sw=;
Message-ID: <466849.91123.qm@web50108.mail.re2.yahoo.com>
X-YMail-OSG: xYAn8AAVM1mANsJmU6.rHWAOjR7k5tVtt6tklaP0EOXNFFvHe.WC7tJSKZiGChMnLIg6GozuphkVUUn9Rsp18LYvOPIj1ztSBWrbTHyCeP79HZJk86GnZW.cedTg6URi.kxMn9zBNsNcghWHaS9cPqpUOtMx.OJPiZC3CvB7uHoDctQn0V6dJf8wzHoR3DUv.mM_1n5vwX_1F7hSGLYRJhPgtO5nmeJR6qY64sK4Esq5AT0pfWBc6lt_74x_SJyScBxsWY2cR6k4UEcK8L9OmiHiEK4u4_ekp81iWZPHTKrEbi3c0dCqlVP3aOga_T7wORTACXe4OA--
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Thu, 30 Apr 2009 07:39:33 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Thu, 4/30/09, Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <andi@firstfloor.org>
> Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
> To: "Doug Thompson" <norsk5@yahoo.com>
> Cc: "Andi Kleen" <andi@firstfloor.org>
> Date: Thursday, April 30, 2009, 1:05 AM
> > The problem we have had is once
> > an Uncorrected Error fires and dumps the address, mapping it
> > to the DIMM silk screen label is difficult, especially in
> > user space, in gaining access to the registers of the
> > controller.  
> 
> You can just do it either after reboot or in the crash
> kernel. I don't
> think it's required to put it all in kernel. Also you don't
> really
> need access to the registers; 

Actually, according to AMD, their reference code for mapping from an error address to a memory slot does require access to the controller's registers. On page 67 of the BKDG for family F10 from their website is 2 and 1/2 pages of the code to perform that mapping. It takes into consideration interleaving of all kinds, etc. It is narly to say the least.

> SMBIOS provides this
> information and
> mcelog knows how to convert it. 

As I undestand SMBIOS it provides a linear assignment of basic memory starts and lengths but does not provide the memory controller context as AMD's reference code takes into consideration

> 
> Trying to add other consumers to mce.c will be likely very
> messy;
> there's really no generic way to do it. I hope you're not
> planning
> turning the nicely CPU independent code in mce.c into a
> mess
> of twisty CPU specific passages like the old 32bit code
> was.
> 
> -Andi

No, not at all. Keeping the "clean" code is paramount, but we are seeking for an interface to accept the MCE error register structure and  map that information to at least a DIMM label field, if not more.

The EDAC module would register for that interface upon loading and unregister upon module unload.

The MCE code would call a stub routine that either returns no mapping occurred OR call the EDAC mapper. MCE could then determine from that return code if a mapping occurred or not. If it did, then display the desired information, otherwise proceed as normal.

doug t

