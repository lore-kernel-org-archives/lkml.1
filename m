Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYE2TZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYE2TZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYE2TZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:25:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbYE2TZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:25:36 -0400
Date: Thu, 29 May 2008 12:24:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, bunk@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] Werror: Remove the packed attribute from
 PofTimStamp_tag in the hysdn driver
Message-Id: <20080529122434.64358db5.akpm@linux-foundation.org>
In-Reply-To: <20080529181746.5396.60932.stgit@warthog.procyon.org.uk>
References: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
	<20080529181746.5396.60932.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 19:17:46 +0100 David Howells <dhowells@redhat.com> wrote:

> Remove the packed attribute from PofTimStamp_tag in the hysdn driver as the
> thing being packed is just an array of chars.

When fixing warnings and build errors, please do quote the compiler
output in the changelog.  Ditto sparse, etc.

> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  drivers/isdn/hysdn/hysdn_pof.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/isdn/hysdn/hysdn_pof.h b/drivers/isdn/hysdn/hysdn_pof.h
> index a368d6c..3a72b90 100644
> --- a/drivers/isdn/hysdn/hysdn_pof.h
> +++ b/drivers/isdn/hysdn/hysdn_pof.h
> @@ -60,7 +60,7 @@ typedef struct PofRecHdr_tag {	/* Pof record header */
>  
>  typedef struct PofTimeStamp_tag {
>  /*00 */ unsigned long UnixTime __attribute__((packed));
> -	/*04 */ unsigned char DateTimeText[0x28] __attribute__((packed));
> +	/*04 */ unsigned char DateTimeText[0x28];
>  	/* =40 */
>  /*2C */
>  } tPofTimeStamp;

I was admiring this the other day.  The compiler (my one at least) says

drivers/isdn/hysdn/hysdn_pof.h:63: warning: 'packed' attribute ignored for field of type 'unsigned char[39u]'

39u != 0x28.  What's up with that?
