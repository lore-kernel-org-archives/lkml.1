Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758626AbYLPXYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbYLPXYQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbYLPXYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:24:00 -0500
Received: from outbound-mail-157.bluehost.com ([67.222.39.37]:48304 "HELO
	outbound-mail-157.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755041AbYLPXYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:24:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=KYLHNEwmpbDkWchKf9Aj/yuQHSwzrBSlQ3NYBl0weBIW1wxOeUSy9mQ2wzHTWrcQTuuXIJ0Z6V61sfJWEYoizxhhaiuA9+7mt/zjlsDADY9iQM55H3V6h4qtOlpUArZn;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yu Zhao <yu.zhao@intel.com>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Date: Tue, 16 Dec 2008 15:23:53 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-pci@vger.kernel.org, achiang@hp.com, bjorn.helgaas@hp.com,
        grundler@parisc-linux.org, greg@kroah.com, mingo@elte.hu,
        matthew@wil.cx, randy.dunlap@oracle.com, rdreier@cisco.com,
        horms@verge.net.au, yinghai@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
In-Reply-To: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161523.55238.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 21, 2008 10:36 am Yu Zhao wrote:
> Greetings,
>
> Following patches are intended to support SR-IOV capability in the
> Linux kernel. With these patches, people can turn a PCI device with
> the capability into multiple ones from software perspective, which
> will benefit KVM and achieve other purposes such as QoS, security,
> and etc.
>
> The Physical Function and Virtual Function drivers using the SR-IOV
> APIs will come soon!
>
> Major changes from v6 to v7:
> 1, remove boot-time resource rebalancing support. (Greg KH)
> 2, emit uevent upon the PF driver is loaded. (Greg KH)
> 3, put SR-IOV callback function into the 'pci_driver'. (Matthew Wilcox)
> 4, register SR-IOV service at the PF loading stage.
> 5, remove unnecessary APIs (pci_iov_enable/disable).

Thanks for your patience with this, Yu, I know it's been a long haul. :)

I applied 1-9 to my linux-next branch; and at least patch #10 needs a respin, 
so can you re-do 10-13 as a new patch set?

On re-reading the last thread, there was a lot of smoke, but very little fire 
afaict.  The main questions I saw were:

  1) do we need SR-IOV at all?  why not just make each subsystem export
     devices to guests?
    This is a bit of a red herring.  Nothing about SR-IOV prevents us from
    making subsystems more v12n friendly.  And since SR-IOV is a hardware
    feature supported by devices these days, we should make Linux support it.

  2) should the PF/VF drivers be the same or not?
    Again, the SR-IOV patchset and PCI spec don't dictate this.  We're free to
    do what we want here.

  3) should VF devices be represented by pci_dev structs?
    Yes.  (This is an easy one :)

  4) can VF devices be used on the host?
    Yet again, SR-IOV doesn't dictate this.  Developers can make PF/VF combo
    drivers or split them, and export the resulting devices however they want. 
    Some subsystem work may be needed to make this efficient, but SR-IOV
    itself is agnostic about it.

So overall I didn't see many objections to the actual code in the last post, 
and the issues above certainly don't merit a NAK IMO...

Given a respin of 10-13 I think it's reasonable to merge this into 2.6.29, but 
I'd be much happier about it if we got some driver code along with it, so as 
not to have an unused interface sitting around for who knows how many 
releases.  Is that reasonable?  Do you know if any of the corresponding PF/VF 
driver bits are ready yet?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

