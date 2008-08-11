Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbYHKVOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbYHKVOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYHKVNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:13:55 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57346 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbYHKVNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:13:54 -0400
In-Reply-To: <20080809184622.GA22905@infradead.org>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221718.4444.11.camel@localhost.localdomain> <20080809184622.GA22905@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       sailer@watson.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>,
       serue@linux.vnet.ibm.com, Al Viro <viro@ZenIV.linux.org.uk>,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Kenneth Goldman <kgold@watson.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
X-KeepSent: 9A2A62B8:D4E0AE57-852574A2:006CEDC6;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.0.1 February 07, 2008
Message-ID: <OF9A2A62B8.D4E0AE57-ON852574A2.006CEDC6-852574A2.00749DAC@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Mon, 11 Aug 2008 17:13:51 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_M1_05262008|May 26, 2008) at
 08/11/2008 17:13:51,
	Serialize complete at 08/11/2008 17:13:51
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote on 08/09/2008 02:46:22 PM:

> > +{
> > +   struct tpm_chip *pos;
> > +
> > +   spin_lock(&driver_lock);
> > +   list_for_each_entry(pos, &tpm_chip_list, list) {
> > +      if ((chip_num == TPM_ANY_NUM || pos->dev_num == chip_num)
> > +          && (chip_typ == TPM_ANY_TYPE)) {
> > +         spin_unlock(&driver_lock);
> > +         return pos;
> > +      }
> > +   }
> > +
> > +   spin_unlock(&driver_lock);
> 
> besides the usual coding style issues, what protects the chip from going
> away afer you dropped the lock?
> 

I assume the concern here is that between looking up the chip and actually 

using the chip, the TPM chip is disabled/deactivated.  Based on 
discussions 
with Kenneth Goldman, the TCG main specification part2: structures, 
require
that even if the TPM is disabled/deactivated, the command to extend the 
PCR 
will succeed, but the command to read the PCR will fail with an 
appropriate 
error code.

Mimi
