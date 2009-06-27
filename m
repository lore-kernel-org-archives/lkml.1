Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbZF0NTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbZF0NTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 09:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbZF0NSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 09:18:55 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:37202 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZF0NSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 09:18:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gPT90VDUVb1tNNNFEpvVBwnpr8j62QWT++6GpQZ2bd1sJVk6rlgtjJZ3lWAwbW2/9/
         MWxxeROJyPYHcNUq23oKm3v2fktIKI+yzkigaFXOz2RWcQBpylAVptpGEyCzB+Ntdo1+
         rgFYejZP+eBWp+nYTkabNVQ9g45vHsXGzaiQ0=
MIME-Version: 1.0
In-Reply-To: <cd40cd91-66e9-469d-b079-3a899a3ccadb@default>
References: <cd40cd91-66e9-469d-b079-3a899a3ccadb@default>
Date: Sat, 27 Jun 2009 15:18:55 +0200
Message-ID: <63386a3d0906270618h5be01265v759f5acd1f49682f@mail.gmail.com>
Subject: Re: [RFC] transcendent memory for Linux
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       npiggin@suse.de, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       Rik van Riel <riel@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/20 Dan Magenheimer <dan.magenheimer@oracle.com>:

> We call this latter class "transcendent memory" and it
> provides an interesting opportunity to more efficiently
> utilize RAM in a virtualized environment.  However this
> "memory but not really memory" may also have applications
> in NON-virtualized environments, such as hotplug-memory
> deletion, SSDs, and page cache compression.  Others have
> suggested ideas such as allowing use of highmem memory
> without a highmem kernel, or use of spare video memory.

Here is what I consider may be a use case from the embedded
world: we have to save power as much as possible, so we need
to shut off entire banks of memory.

Currently people do things like put memory into self-refresh
and then sleep, but for long lapses of time you would
want to compress memory towards lower addresses and
turn as many banks as possible off.

So we have something like 4x16MB banks of RAM = 64MB RAM,
and the most necessary stuff easily fits in one of them.
If we can shut down 3x16MB we save 3 x power supply of the
RAMs.

However in embedded we don't have any swap, so we'd need
some call that would attempt to remove a memory by paging
out code and data that has been demand-paged in
from the FS but no dirty pages, these should instead be
moved down to memory which will be retained, and the
call should fail if we didn't succeed to migrate all
dirty pages.

Would this be possible with transcendent memory?

Yours,
Linus Walleij
