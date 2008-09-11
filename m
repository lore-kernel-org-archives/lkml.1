Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYIKBvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYIKBvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 21:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbYIKBvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 21:51:40 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:56276 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYIKBvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 21:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=ptvxztO/z770o3tns/cI6TcZ35z6Voe1lMbL1ilbdRptKw4hn1W/SF3QUqovCt1T15
         pvkS8VsSeiAsg9b31TRKVeLh42c1oWZbGWuRX1xSux4gMPhe6swFjAanwrv87ShoS0jn
         KKajWPWo9SHhdMUO5QVOblvmdmQO4/qyAsIrg=
Message-ID: <41b516cb0809101851p79f73499vbd10dec4f6bdeccb@mail.gmail.com>
Date: Wed, 10 Sep 2008 18:51:37 -0700
From: "Chris Leech" <christopher.leech@intel.com>
Reply-To: chris.leech@gmail.com
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros for accessing 3-byte arrays as integers
Cc: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, devel@open-fcoe.org
In-Reply-To: <48C7F19D.3080507@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
	 <20080910140712.GA12280@infradead.org>
	 <1221061241.27385.14.camel@norville.austin.ibm.com>
	 <48C7F19D.3080507@panasas.com>
X-Google-Sender-Auth: 20cb85bf9dfc9467
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 9:11 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> Chris you might want to change the definitions at linux/types.h
> to:
>
> typedef struct { __u8 b[3]; } __be24, __le24 __packed;
>
> With gcc it will not help with the proceeding fields, and the
> containing struct will need it's own "__packed" declaration
> but it will keep it packed with previous fields.

I haven't seen padding added simply because of a nested structure
boundary, but I'm not up on all the ABIs for the different
architectures.  Obviously a containing structure would want to have
the 24-bit type adjacent to an 8-bit type, or have it's own packed
attribute if needed.

It shouldn't hurt, in this case the members shouldn't be expected to
have more than byte alignment anyway, but I can't see how it would
help.

If there's a particular arch that might be a problem I'm happy to look
into it, but I don't want to start throwing packed attributes around
just in case.

Chris
