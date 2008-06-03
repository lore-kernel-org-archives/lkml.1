Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbYFCWet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbYFCWet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbYFCWel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:34:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430AbYFCWek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:34:40 -0400
Date: Tue, 3 Jun 2008 15:33:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: sct@redhat.com, adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz, jbacik@redhat.com,
       cmm@us.ibm.com, tytso@mit.edu, yumiko.sugita.yf@hitachi.com,
       satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH 2/5] jbd: ordered data integrity fix
Message-Id: <20080603153304.741eaa2b.akpm@linux-foundation.org>
In-Reply-To: <4843CF30.9050801@hitachi.com>
References: <4843CE15.6080506@hitachi.com>
	<4843CF30.9050801@hitachi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 19:45:04 +0900
Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:

> In ordered mode, if a buffer being dirtied exists in the committing

I changed this text to read "if a file data buffer being dirtied". 
Please do be careful when describing all these buffers, else it gets
more confusing that it already is.


> transaction, we write the buffer to the disk, move it from the
> committing transaction to the running transaction, then dirty it.
> But we don't have to remove the buffer from the committing
> transaction when the buffer couldn't be written out, otherwise it
> would miss the error and the committing transaction would not abort.
> 
> This patch adds an error check before removing the buffer from the
> committing transaction.
