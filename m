Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbZEYNVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbZEYNVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZEYNVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:21:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:37829 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbZEYNVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:21:09 -0400
Message-ID: <4A1A9B47.2090208@suse.cz>
Date: Mon, 25 May 2009 15:21:11 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] kbuild: handle non-existing options in scripts/config
References: <cover.1243255664.git.mmarek@suse.cz> <20090525125540.GB12943@sepie.suse.cz> <20090525131144.GZ846@one.firstfloor.org>
In-Reply-To: <20090525131144.GZ846@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen napsal(a):
>> -replace() {
>> -	sed -i -e "$@" $FN
>> +# set_var name value [before-var]
>> +set_var() {
>> +	awk -vvar="$1" -vnew="$2" -vbefore="$3" '
> 
> This seems rather complicated compared to what was there before.

Calling the function is simpler otoh...


> I would just cmp the output file to the input file and if they are
> the same then add it at the end with a echo

Just doing that would duplicate the variable if it was already set to
the desired value, causing a "warning: override: reassigning to symbol"
warning from kbuild.

Hmm, willll try to simplify it somehow.


> 
>> +	}
>> +	' "$FN" >"$FN.tmp"
> 
> This should be a &&, otherwise you risk removing the output file
> on ctrl-c

Ah, good point.

Michal
