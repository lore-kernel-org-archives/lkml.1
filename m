Return-Path: <linux-kernel-owner+w=401wt.eu-S1161122AbXBUIfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161122AbXBUIfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbXBUIfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:35:43 -0500
Received: from smtp-out.google.com ([216.239.33.17]:42362 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbXBUIfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:35:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=xkSGtvw36DvRCXWxVRQ9BWLzRqmYjXWtV58d/J+HZbKkRI0iEowYIvjrObEw1hk02
	tNuJ0XgJ/tuUDetIScBQw==
Message-ID: <b040c32a0702210035w38dda81du55bc12259324a4b5@mail.gmail.com>
Date: Wed, 21 Feb 2007 00:35:34 -0800
From: "Ken Chen" <kenchen@google.com>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
Subject: Re: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Cc: "Chris Mason" <chris.mason@oracle.com>,
       "Zach Brown" <zach.brown@oracle.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, "Benjamin LaHaise" <bcrl@kvack.org>,
       "Suparna bhattacharya" <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC871E37@mssmsx411>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070220175457.GS6133@think.oraclecorp.com>
	 <B41635854730A14CA71C92B36EC22AAC871E37@mssmsx411>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/07, Ananiev, Leonid <leonid.i.ananiev@intel.com> wrote:
> 1) mem=1G in kernel boot param if you have more
> 2) unmount; mk2fs; mount
> 3) dd if=/dev/zero of=<test_file> bs=1M count=1200
> 4) aiostress -s 1200m -O -o 2 -i 1 -r 16k <test_file>
> 5) if i++<50 goto 2).

Would you please instrument the call chain of
invalidate_complete_page2() and tell us exactly where it returns zero
value in your failure case?

   invalidate_complete_page2
      try_to_release_page
         ext3_releasepage
            journal_try_to_free_buffers
               ???
