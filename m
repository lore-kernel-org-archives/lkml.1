Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbZAVXNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbZAVXNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbZAVXNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:13:41 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:56453 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbZAVXNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:13:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bNTvm2Ql4Ws29APNA476u5TO+7KPeghZwWzhdo8GAHXk6an6FJrnkmYIalMO7Gr5Ds
         1DtKEKIiQZmvur8rblbO4rVzM9x5Q971Ix925OoBQuJb55g/gYSNuzlmA04ruf3s4UBW
         psyWxP08irA6mFSQ0l+PyAzKNUJadQsuKIJ0Y=
MIME-Version: 1.0
In-Reply-To: <20090122210655.GA6065@infradead.org>
References: <1232642078-9717-1-git-send-email-jlayton@redhat.com>
	 <20090122210655.GA6065@infradead.org>
Date: Thu, 22 Jan 2009 17:13:37 -0600
Message-ID: <524f69650901221513m7857488by6713eca64ee31681@mail.gmail.com>
Subject: Re: [linux-cifs-client] [PATCH] cifs: wrap cifs_dnotify_thread in 
	CONFIG_BROKEN
From: Steve French <smfrench@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thread may be renamed/rewritten etc. - but we badly need to finish
the dnotify / inotify code ... removing the start on this that someone
wrote in the past isn't getting us any closer to this.

dnotify/inotify support was added to Linux in the first place because
Samba used it to handle this common operation (it is commonly used by
OTHER cifs clients) ... but none of the Linux cluster/network file
systems have had time to finish the code ... we need to finish this -
the network protocol portion of this is now well documented (and we
presumably will need a thread to process the dnotify multishot
notification responses so we don't clog up the demultiplex thread
waiting on kde and gnoe)

On Thu, Jan 22, 2009 at 3:06 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Jan 22, 2009 at 11:34:38AM -0500, Jeff Layton wrote:
>> This thread never actually did anything useful, so comment it out by
>> #ifdef'ing it in CONFIG_BROKEN. My preference would be to remove it
>> altogether, but it's not my call.
>
> Please just kill it.  It's not only useless but also ugly, so keeping it
> around it a double disservice to the mother nature.
>
>



-- 
Thanks,

Steve
