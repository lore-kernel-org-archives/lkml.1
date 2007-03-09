Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbXCIEFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbXCIEFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 23:05:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXCIEFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 23:05:03 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:55926 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbXCIEFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 23:05:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mrp/UrptbGVGvsSeVGcoq8R8yypLsgkk8xjHrOErZztRRcanTx2EimVYUWHAbw4RxO9Qmjaqy4YpC8IGK/cSYNW0IEiyP/lc67amaKq5CEdN4yVv5p7LG2f+SV+uBt8d86mP69DK6sO5yruBSQN20BrPGmuVpOZQ+tIyxwIEco4=
Message-ID: <4e5ebad50703082004s6cd34ccbp34e6f8b2c2273389@mail.gmail.com>
Date: Fri, 9 Mar 2007 12:04:59 +0800
From: "Sonic Zhang" <sonic.adi@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
Cc: "Bryan Wu" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       mhfan@ustc.edu
In-Reply-To: <20070308102738.2ec69c60.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1173164058.31825.16.camel@roc-desktop>
	 <20070306214301.GA5590@martell.zuzino.mipt.ru>
	 <1173247078.28531.24.camel@roc-desktop>
	 <20070307075822.53e53c42.khali@linux-fr.org>
	 <1173261197.28531.60.camel@roc-desktop>
	 <20070308102738.2ec69c60.khali@linux-fr.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Brian,
>
> Thanks for the quick update.



> > +
> > +     rc = (iface->result >= 0) ? 0 : -1;
> > +
> > +     /* Release mutex */
> > +     mutex_unlock(&iface->twi_lock);
> > +
> > +     return rc;
> > +}
>
> i2c-core can emulate SMBus transactions using master_xfer, so in
> general when you have a complete master_xfer implementation you do not
> need to define a separate smbus_xfer function. This would save a lot of
> code.
>

Actually the i2c-core can't emulate SMBus transactions using the
master_xfer function, because the blackfin TWI controller provide
hardware support to the SMBus transactions and the combination of
master_xfer operations can't generate proper signal for SMBus.
