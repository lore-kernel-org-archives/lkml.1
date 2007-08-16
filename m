Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbXHPS2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbXHPS2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 14:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbXHPS2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 14:28:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:4877 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbXHPS2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 14:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UwblxnUz0BAClKzAplFqVE/qQRFV1VdvKZA8l7tKaCWn8+ByV4deMEubrQ8dvMXWNNQTZA66qjVwvCtMhyk4/DzD+ejrHhoTLW1ca/M4DDWwyzK7zyLvm7MFahYMebyvoPR+iuFmq0ug6iw38vdiAai7ReGdSHjLTCewHMqIuzc=
Message-ID: <8bd0f97a0708161128g71ca385ak6ddcb1b36d7fabc2@mail.gmail.com>
Date: Thu, 16 Aug 2007 14:28:43 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jie Zhang" <jie.zhang@analog.com>
Subject: Re: [PATCH 1/2] Add a new field `name' to struct linux_binfmt
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1187248823.11475.24.camel@mercury.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187248823.11475.24.camel@mercury.analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/07, Jie Zhang <jie.zhang@analog.com> wrote:
> This patch addes a new `name' field to struct linux_binfmt and
> initialize it in each binfmt type.
>
> A second blackfin arch patch will use this field to distinguish `flat'
> binfmt with `FDPIC ELF'.
>
> Is it OK? Any comments?

the other possibility would be to not make linux_binfmt definitions
static and put appropriate prototypes in the fs.h header ... then you
could do:
if (current->binfmt == aout_format) {
  ... aout stuff ...
}

then again, this goes against the dynamic nature of the binfmt itself
... and the idea that the binfmt should not matter to anything else in
the kernel once it's executing ...
-mike
