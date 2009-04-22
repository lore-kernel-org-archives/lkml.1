Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbZDVCTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbZDVCTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 22:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbZDVCTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 22:19:42 -0400
Received: from n23b.bullet.mail.mud.yahoo.com ([68.142.206.142]:27817 "HELO
	n23b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751281AbZDVCTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 22:19:41 -0400
X-Yahoo-Newman-Id: 200550.55241.bm@omp415.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WVQkjd3UnsUCxv7Fdt7Ym6bRNB8OaHmzGZf5wB51CG6YDlAAx7Mrzfm/hmZU/hbiRvKEka0zI/5+tISouCS3Cv6pkvuZGQbNcaol4biFopai1Ax42Es1Rmpo/Pgup5t6Iw2X6OcnI9xld5z9Q+VFvoQPyWBVmovVZMmIneqAAJU=  ;
X-YMail-OSG: svFh6ScVM1k3FOgu37aCVRCWz5IKpEvKbOxDXqlOZCDTXI.EzLrm9ljhyHl6OEsgURGdwHli7CNtt7GQdcmJqqYRBbMpTyM_TTSsszES6xojCWZHFgU1S6fifn3NenT52zqKhBFQhgPDyPuoLtXc4V0j39E4ZGOU3Iw3rQAI7h2SGdbijESOlFzb0tC0m.Rei60cDyADg6pPxPjNfM5FIWXU3oIEIHnAvIHw6qjZHCz1kKgssiLtp_5GLYg8Sc7rskUp1jROlYQRRz1W
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [BUILD FAILURE 11/12] Next April 21 : PPC64 randconfig [drivers/usb/host/ohci-hcd.o]
Date: Tue, 21 Apr 2009 19:19:37 -0700
User-Agent: KMail/1.9.10
Cc: Kumar Gala <galak@kernel.crashing.org>, subrata@linux.vnet.ibm.com,
       linux-usb@vger.kernel.org, "Linuxppc-dev" <Linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next" <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
References: <1240340081.9110.144.camel@subratamodak.linux.ibm.com> <5A202317-5104-4784-845B-B8C46E0A3C48@kernel.crashing.org> <49EE4341.50701@oracle.com>
In-Reply-To: <49EE4341.50701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904211919.38104.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 April 2009, Randy Dunlap wrote:
> 
> > Since its feasible to say 'n' to both we get the compile error.  How do
> > we enforce having at least one set?
> 
> Looks like using "choice" without "optional" would do it.
> See Documentation/kbuild/kconfig-language.txt and various examples
> in Kconfig* files.

That won't quite work ... "at least one" includes "two"
(i.e. a PCI card in little-endian, a native controller
in big-endian).  Real-world systems need such configs,
or so I'm told, and that's why their supported.

Is there maybe a way to force Kconfig to just reject
such illegal configs -- neither option set -- rather
than trying some how to fix it?

Or maybe ... if neither one is set, have the header
force both on, and issue a warning.


