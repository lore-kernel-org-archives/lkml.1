Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbZEYNFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbZEYNFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbZEYNFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:05:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60057 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbZEYNFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:05:21 -0400
Date: Mon, 25 May 2009 15:11:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] kbuild: handle non-existing options in scripts/config
Message-ID: <20090525131144.GZ846@one.firstfloor.org>
References: <cover.1243255664.git.mmarek@suse.cz> <20090525125540.GB12943@sepie.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525125540.GB12943@sepie.suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -replace() {
> -	sed -i -e "$@" $FN
> +# set_var name value [before-var]
> +set_var() {
> +	awk -vvar="$1" -vnew="$2" -vbefore="$3" '

This seems rather complicated compared to what was there before.

I would just cmp the output file to the input file and if they are
the same then add it at the end with a echo

> +	}
> +	' "$FN" >"$FN.tmp"

This should be a &&, otherwise you risk removing the output file
on ctrl-c

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
