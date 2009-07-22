Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZGVWZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZGVWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZGVWZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:25:56 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:41547 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752734AbZGVWZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:25:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tZ6/F9SwhnIv3hyItS24QyVOCJ0iPxJ2yitk7s6W01eIZr3Ktba3SaPuhVFoFHsEmSQHrshhW6zVaKlb7GOzwrUs70OxX5tr0T6eVaLmDpvNMYTsNBB2tr4NFcZ+znUU2FqwkZ9v7sac+jyFI2I5xl876UcKjagdZ2Af+a43DE8=  ;
X-YMail-OSG: hTyRVVEVM1m_Mrbw10TLNwtEfWVH2JjUNVzjg26b4IlsacluimDX9e4pEDl2INLjNldkx0Kzggldev6SzcUErpjMd3j5twNj078UkE1pjqOTH3xfCcMHenPUdF7PRreQUbFKJ6Sos6LSFB4k3wUCsv87FZ9NLBkKlsBqw9p8tIC3yWX4A0VFfDKcnARrIciW9xEqGUYqFWN47AE3m4_sGp6agPjaNuKvtq1H2uCuEvBl0iPvcrmuRvpwb_NV0rXIgIqrtFY7S_6ntwBk
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Trilok Soni <soni.trilok@gmail.com>
Subject: Re: [PATCH 2/2] mfd: twl4030: add twl4030-pwrbutton as our child
Date: Wed, 22 Jul 2009 15:25:53 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, Samuel Ortiz <sameo@linux.intel.com>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090227154220.7099f339.akpm@linux-foundation.org> <5d5443650907221227w72768b3cna145cea00f1baa05@mail.gmail.com>
In-Reply-To: <5d5443650907221227w72768b3cna145cea00f1baa05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907221525.53890.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Trilok Soni wrote:
> > That doesn't address the problem at all.  A function called
> > "add_children" just shouldn't exist.  The general kernel design is for
> > client drivers to register themselves with the core, so the core does
> > not have any hard-wired knowledge of any client drivers.

The general kernel design also involves bus drivers
(consider PCI or USB) enumerating their child devices
and then *adding* those children ... that's what is
done here.  The devices supported by that system get
added, and then the driver model code can bind each
device to its driver.


> > IOW, twl4030_pwrbutton_probe() should call into twl4030-core,
> > registering the powerbutton driver.

It calls to the driver model to register that driver,
which then sees that the device is registered.

- Dave


> 
> Reviving this very old thread.
> 


