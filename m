Return-Path: <linux-kernel-owner+w=401wt.eu-S1751280AbYKFQs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbYKFQs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYKFQsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:48:30 -0500
Received: from n72.bullet.mail.sp1.yahoo.com ([98.136.44.34]:40132 "HELO
	n72.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752621AbYKFQsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:48:20 -0500
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2008 11:48:20 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 187709.89247.bm@omp201.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=znX8SZ3x1VdBa16Md4AmHOofKAhmh+iQ7Lzu4NX28RuvcnZ0ePkQBGdY66jTdQvohme/cZhsgsndqPM7qtyfXv/TNiymtG1inVbeY97Z2HkhWvayX2H0i5OexSwH/iLzZyu7fYI5f5ku1ulPNPRcu7Dr5nvaeUGKgOtptScSTFA=;
X-YMail-OSG: hwzxL8oVM1lei1nvK0mosaTPFQnDwha0D5CCpGUKld99Px_b4XXjgmJkpiZj_vytkBF_SkicHNHTO7K4UG6f5foZMQOjd1LT4yqwtyChiZnwiF35FpHEqJc4iYP4gc6yOfz7bcNhKxFruV94Cx.zkZKsVCRA
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 6 Nov 2008 08:41:53 -0800 (PST)
From: H L <swdevyid@yahoo.com>
Reply-To: swdevyid@yahoo.com
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
To: Greg KH <greg@kroah.com>
Cc: Yu Zhao <yu.zhao@intel.com>, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <20081106154351.GA30459@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <894107.30288.qm@web45108.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have not modified any existing drivers, but instead I threw together a bare-bones module enabling me to make a call to pci_iov_register() and then poke at an SR-IOV adapter's /sys entries for which no driver was loaded.

It appears from my perusal thus far that drivers using these new SR-IOV patches will require modification; i.e. the driver associated with the Physical Function (PF) will be required to make the pci_iov_register() call along with the requisite notify() function.  Essentially this suggests to me a model for the PF driver to perform any "global actions" or setup on behalf of VFs before enabling them after which VF drivers could be associated.

I have so far only seen Yu Zhao's "7-patch" set.  I've not yet looked at his subsequently tendered "15-patch" set so I don't know what has changed.    The hardware/firmware implementation for any given SR-IOV compatible device, will determine the extent of differences required between a PF driver and a VF driver.

--
Lance Hartmann


--- On Thu, 11/6/08, Greg KH <greg@kroah.com> wrote:


> Date: Thursday, November 6, 2008, 9:43 AM
> On Thu, Nov 06, 2008 at 07:40:12AM -0800, H L wrote:
> > 
> > Greetings (from a new lurker to the list),
> 
> Welcome!
> 
> > To your question Greg, "yes" and "sort
> of" ;-).  I have started taking
> > a look at these patches with a strong interest in
> understanding how
> > they work.  I've built a kernel with them and
> tried out a few things
> > with real SR-IOV hardware.
> 
> Did you have to modify individual drivers to take advantage
> of this
> code?  It looks like the core code will run on this type of
> hardware,
> but there seems to be no real advantage until a driver is
> modified to
> use it, right?
> 
> Or am I missing some great advantage to having this code
> without
> modified drivers?
> 
> thanks,
> 
> greg k-h


      

