Return-Path: <linux-kernel-owner+w=401wt.eu-S1946265AbXBIKPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946265AbXBIKPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946304AbXBIKPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:15:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41488 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946265AbXBIKPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:15:33 -0500
Date: Fri, 9 Feb 2007 02:14:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       linux-kernel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
       Zach Brown <zach.brown@oracle.com>, suparna@in.ibm.com,
       Chris Mason <chris.mason@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] aio: fix kernel bug when page is  temporally busy
Message-Id: <20070209021444.2213deb6.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702091042330.25686@twin.jikos.cz>
References: <B41635854730A14CA71C92B36EC22AAC8048C3@mssmsx411>
	<Pine.LNX.4.64.0702091042330.25686@twin.jikos.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 10:54:36 +0100 (CET) Jiri Kosina <jikos@jikos.cz> wrote:

> @@ -1204,7 +1204,7 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
>  			do_generic_file_read(filp,ppos,&desc,file_read_actor);
>  			retval += desc.written;
>  			if (desc.error) {
> -				retval = retval ?: desc.error;
> +				retval = desc.error;
>  				break;
>  			}

Nope.  On error the read() syscall must return the number of bytes which
were successfully read.
