Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbXCZRzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbXCZRzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 13:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXCZRzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 13:55:44 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:34787 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbXCZRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 13:55:43 -0400
Subject: Re: [Patch 3/7] integrity: EVM as an integrity service provider
From: David Safford <safford@watson.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
In-Reply-To: <20070325121321.GA8550@ucw.cz>
References: <1174666176.11149.3.camel@localhost.localdomain>
	 <20070325001605.31ed39e7.akpm@linux-foundation.org>
	 <20070325121321.GA8550@ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Mar 2007 13:55:15 -0400
Message-Id: <1174931715.3493.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 12:13 +0000, Pavel Machek wrote:
> > > +	  The Extended Verification Module is an integrity provider.
> > > +	  An extensible set of extended attributes, as defined in
> > > +	  /etc/evm.conf, are HMAC protected against modification
> > > +	  using the TPM's KERNEL ROOT KEY, if configured, or with a
> > > +	  pass-phrase.  Possible extended attributes include authenticity,
> > > +	  integrity, and revision level.
> 
> What is identity provider good for? Can you explain it a bit more, or
> perhaps point to Doc*/ somewhere?
> 							Pavel

There are some papers and related userspace code at
   http://www.research.ibm.com/gsal/tcpa
which describe the architecture in more detail, but basically this 
integrity provider is designed to complement mandatory access control
systems like selinux and slim. Such systems can protect a running system 
against on-line attacks, but do not protect against off-line attacks  
(booting Knoppix and changing executables or their selinux labels), or 
against attacks which find weaknesses in the kernel or the LSM module 
itself.

Using a TPM or passphrase, EVM can verify the integrity of all files 
(including the kernel and initrd) and their labels before they are 
referenced. Using a TPM, EVM/IMA can attest to the integrity of all files 
to a third party, even if the kernel or modules have been compromised.
(An attack can block the attestation, but cannot forge valid TPM 
signatures.)

In response to customer demand, we are actively working to develop and 
test this attestation in enterprise server environments, integrated 
with both selinux and AppArmor.

dave


