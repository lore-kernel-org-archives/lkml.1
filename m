Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYAQMsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYAQMsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYAQMr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:47:58 -0500
Received: from smtp-out.google.com ([216.239.45.13]:22582 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYAQMr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:47:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=M7hwe7NEl7yp3f0canL0r1q1zA/Gz/YVGnPJS+2pb2Ld9AqUKmy9TXeQyooF9dIPe
	z4W9HM01WGriPr+8gmpBg==
Message-ID: <d9885f0f0801170447r1c2bfeb9l6c911bfa0113366f@mail.gmail.com>
Date: Thu, 17 Jan 2008 07:47:54 -0500
From: "Abhishek Rai" <abhishekrai@google.com>
To: "Theodore Tso" <tytso@mit.edu>, "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Abhishek Rai" <abhishekrai@google.com>, linux-kernel@vger.kernel.org,
       rohitseth@google.com, linux-ext4@vger.kernel.org
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm patch]
In-Reply-To: <20080115152801.GA7292@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801140839.01986.abhishekrai@google.com>
	 <20080114163412.83a8b18d.akpm@linux-foundation.org>
	 <20080115030441.a0270609.akpm@linux-foundation.org>
	 <20080115131533.GA5766@infradead.org> <20080115152801.GA7292@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008 10:28 AM, Theodore Tso <tytso@mit.edu> wrote:
> Also, it's not just reducing fsck times, although that's the main one.
> The last time this was suggested, the rationale was to speed up the
> "rm dvd.iso" case.  Also, something which *could* be done, if Abhishek
> wants to pursue it, would be to pull in all of the indirect blocks
> when the file is opened, and create an in-memory extent tree that
> would speed up access to the file.  It's rarely worth doing this
> without metaclustering, since it doesn't help for sequential I/O, only
> random I/O, but with metaclustering it would also be a win for
> sequential I/O.  (This would also remove the minor performance
> degradation for sequential I/O imposed by metaclustering, and in fact
> improve it slightly for really big files.)
>
>                                         - Ted
>

Also, since the in memory extent tree will now occupy much less space,
we can keep them cached for a much longer time which will improve
performance of random reads. The new metaclustering patch is more
amenable to this trick since it reduces fragmentation thereby reducing
the number of extents.

Thanks,
Abhishek
