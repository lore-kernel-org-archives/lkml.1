Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbYETGNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbYETGNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 02:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbYETGNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 02:13:14 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:25354 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754065AbYETGNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 02:13:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vy4tJhECzC22okAdL6A3F/Yl4yTj0xufYcq0J4NOYvkh9JJ499la258/9pJCc/oCFUA1JpF5gkI7fa01G8G9eI1/ZVIvVlDihUUpazytqT5QRRF2U/TBsmOFJmpfQkpMowJM+lhZ5n5t+rctJCzeE1j0EGtX+bDOFYH2OM4OOAQ=  ;
X-YMail-OSG: WN4ZfgoVM1kSubhkjV024R9lrweyW.4XkZoGKz2jWFCu1FbDOo1Cs0lO9EmN6Yvy6PTro9VqhXhq961LEizFJGdETawQiAUrt1CrNiL_2TZY525NaouRMbAdOb5PLz88N2I-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [Bug #10713] ehci splatter in 2.6.26-rc2
Date: Mon, 19 May 2008 23:13:11 -0700
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, nico@cam.org
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <20080519231126.GA15099@xi.wantstofly.org> <20080520001824.GA15878@xi.wantstofly.org>
In-Reply-To: <20080520001824.GA15878@xi.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805192313.11600.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008, Lennert Buytenhek wrote:
> A bisect turns up this:
> 
>         7329e211b987a493cbcfca0e98c60eb108ab42df is first bad commit
>         commit 7329e211b987a493cbcfca0e98c60eb108ab42df
>         Author: Alan Stern <stern@rowland.harvard.edu>
>         Date:   Thu Apr 3 18:02:56 2008 -0400
> 
>             USB: root hubs don't lie about their number of TTs
>             
>             Currently EHCI root hubs enumerate with a bDeviceProtocol code
>             indicating that they possess a Transaction Translator.  However the
>             vast majority of controllers do not...
> 
> And indeed, reverting this commit from 2.6.26-rc3 makes my system
> stop oopsing when I plug in the USB-PS/2 adapter (a low speed device),
> and makes it work again as it did in 2.6.25.
> 
> Any other info I can provide or tests I can run?

I'm guessing that this has a version of the ARC/TDI/whoever-now-owns-it
IP, on a PCI bus?  But without the integrated TT option?

If this is on a PCI bus, then try removing the ehci-pci.c line added
by that patch, see if that helps.

- Dave

