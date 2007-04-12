Return-Path: <linux-kernel-owner+w=401wt.eu-S1030669AbXDLSXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030669AbXDLSXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030682AbXDLSXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:23:08 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:39599 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030666AbXDLSXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:23:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B7b6whszAdOM8E5BVooPkRhIZHNK7D8VZ6Dfttwb2tnQcDsUrOLAShADg2ER4z9+jreOrujlGGoOt8xmXQn07/a/9lYsx1xE895lO15LxaEiRIXZnk5vTBTXnCJWd8ZMi1qzRviDvB4oq+LSzWMpwtO0OAYNf3CVPg3Y+/rU090=
Message-ID: <5c49b0ed0704121123x341d10afxfdf6930b4b26417b@mail.gmail.com>
Date: Thu, 12 Apr 2007 11:23:03 -0700
From: "Nate Diller" <nate.diller@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH 3/17] afs: convert afs_dir_get_page to read_kmap_page
Cc: "Andrew Morton" <akpm@osdl.org>,
       "Alexander Viro" <viro@zeniv.linux.org.uk>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Dave Kleikamp" <shaggy@austin.ibm.com>,
       "Anton Altaparmakov" <aia21@cantab.net>,
       "Evgeniy Dushistov" <dushistov@mail.ru>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-dev@namesys.com
In-Reply-To: <1273.1176375482@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070412024938.27380.44677.patchbomb.py@localhost>
	 <1273.1176375482@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/07, David Howells <dhowells@redhat.com> wrote:
> Nate Diller <nate.diller@gmail.com> wrote:
>
> > -static struct page *afs_dir_get_page(struct inode *dir, unsigned long index)
>
> NAK.  This conflicts with my AFS security patches, and eliminates any way of
> passing the key through to readpage().

Hmmm you're right.  Is your security work going into the next -mm?  If
so, I'll just re-base this cleanup patch on that ... at the very least
I want to get rid of afs_dir_put_page().  Also, did you consider
passing the key pointer directly and modifying the readpage actor to
simply cast the pointer back, like read_mapping_page(mapping, page,
(struct file *)key)?  It seems like a waste to allocate a whole file
struct on the stack just for the ->private field.

Andrew in the mean time just disregard this patch.

NATE
