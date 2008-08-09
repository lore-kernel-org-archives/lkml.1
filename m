Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbYHISqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbYHISqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 14:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYHISqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 14:46:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYHISqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 14:46:23 -0400
Date: Sat, 9 Aug 2008 14:46:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
Message-ID: <20080809184622.GA22905@infradead.org>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221718.4444.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218221718.4444.11.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +{
> +	struct tpm_chip *pos;
> +
> +	spin_lock(&driver_lock);
> +	list_for_each_entry(pos, &tpm_chip_list, list) {
> +		if ((chip_num == TPM_ANY_NUM || pos->dev_num == chip_num)
> +		    && (chip_typ == TPM_ANY_TYPE)) {
> +			spin_unlock(&driver_lock);
> +			return pos;
> +		}
> +	}
> +
> +	spin_unlock(&driver_lock);

besides the usual coding style issues, what protects the chip from going
away afer you dropped the lock?

