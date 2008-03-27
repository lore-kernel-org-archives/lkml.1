Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbYC0BWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbYC0BWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 21:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbYC0BWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 21:22:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:44176 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025AbYC0BWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 21:22:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oh7H8PkY1//biDqyfR+oq8fv3qe39Rgeoo64HyAJfAEqCPGvMP3g4oYhmHNzEEW8fxggCJhlPWhgpuCJ+ZskIIr2nQjTSldeTd8e2WmK0edCdRTA3FJQMMVSBk0ZuNxp6SJIDBteXTQpInNMYj/M5XpNtIbTdQkxDPG9DsMfXEg=
Subject: Re: [PATCH 6/7] omfs: add checksumming routines
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1206578760-9050-6-git-send-email-me@bobcopeland.com>
References: <1206578760-9050-6-git-send-email-me@bobcopeland.com>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 18:22:01 -0700
Message-Id: <1206580921.24940.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-26 at 20:45 -0400, Bob Copeland wrote:
> OMFS checksums the metadata of all filesystem objects.  This change adds
> the necessary functions to do so.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  fs/omfs/checksum.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)
>  create mode 100644 fs/omfs/checksum.c
> 
> diff --git a/fs/omfs/checksum.c b/fs/omfs/checksum.c
> new file mode 100644
> index 0000000..d6f1023
> --- /dev/null
> +++ b/fs/omfs/checksum.c
> @@ -0,0 +1,48 @@
> +#include <linux/fs.h>
> +#include <linux/buffer_head.h>
> +#include "omfs.h"
> +
> +#define POLY 0x1021
> +
> +/*
> + * crc-ccitt with MSB first (i.e., backwards), so we can't use the
> + * kernel table as-is.
> + */

Why not just add a be-bitwise table, similar to the crc32_le and
crc32_be implementation.


Harvey

