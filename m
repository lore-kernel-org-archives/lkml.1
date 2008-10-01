Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYJAId2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYJAId2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYJAIdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:33:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:7777 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYJAIdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:33:19 -0400
Message-ID: <f488382f0810010133j50f70705w59f207434a6b025e@mail.gmail.com>
Date: Wed, 1 Oct 2008 01:33:17 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] sdhci: 'scratch' may be used uninitialized
Cc: mingo@elte.hu, drzeus@drzeus.cx, "Steven Noonan" <steven@uplinklabs.net>
In-Reply-To: <1222848842-10798-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081001080048.GB25832@elte.hu>
	 <1222848842-10798-1-git-send-email-steven@uplinklabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2008 at 1:14 AM, Steven Noonan <steven@uplinklabs.net> wrote:
> -       u32 scratch;
> +       u32 uninitialized_var(scratch);

A bit of a further explanation:

The variable 'scratch' is always initialized before it's used. The
conditional which is responsible for initialization of 'scratch' will
always evaluate 'true' when the first loop iteration occurs, and thus,
it's properly initialized. GCC doesn't see this, of course, so using
the uninitialized_var() macro seems to work for silencing this case.

- Steven
