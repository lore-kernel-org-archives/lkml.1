Return-Path: <linux-kernel-owner+w=401wt.eu-S1763059AbYCEHKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763059AbYCEHKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYCEHKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:10:04 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:21873 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbYCEHKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:10:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q/IFOBh0elRi+IEfExLfDOM5SNOUbxVXkyqi6eKFAuyKpBdzUFhpFcZgFM1dbIqFnBJp42HnNfcq/gaCe/6kZn2T9DSum2ZBppu26Bzt4N20ZlgohIB66QsmzOmi/9czmfvWANumB39XE7UUSvUvAdrnsHTuUKHzVr3vE4ZS5gc=
Subject: Re: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct
	use of ! and &
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christopher Li <sparse@chrisli.org>, Julia Lawall <julia@diku.dk>,
       yi.zhu@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Alexander Viro <viro@ftp.linux.org.uk>,
       linux-sparse@vger.kernel.org, Josh Triplett <josh@freedesktop.org>
In-Reply-To: <20080305070201.GA32434@elte.hu>
References: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk>
	 <20080305063842.GA24495@elte.hu>
	 <70318cbf0803042249j57d7f3a3j7666961a9132b10b@mail.gmail.com>
	 <20080305070201.GA32434@elte.hu>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 23:09:55 -0800
Message-Id: <1204700995.17484.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-05 at 08:02 +0100, Ingo Molnar wrote:
> * Christopher Li <sparse@chrisli.org> wrote:
> 
> > I think Al Viro has sent a patch to linux-sparse with subject "[PATCH 
> > 3/3] catch !x & y brainos" does exactly that.
> 
> ah - nice :-)
> 
> /me checks the linux-sparse archive
> 
> Al's patch is:
> 
> +                       if (op == '&' && expr->left->type == EXPR_PREOP &&
> +                           expr->left->op == '!')
> +                               warning(expr->pos, "dubious: !x & y");
> 
> i think there might be similar patterns: "x & !y", "!x | y", "x | !y" ?
> 

Well, (!x & y) and (!x | y) are probably the two that might have been
intended otherwise.  (x & !y), (x | !y) are probably ok.

Harvey

