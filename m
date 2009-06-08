Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZFHB3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZFHB3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 21:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZFHB30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 21:29:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33547 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbZFHB3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 21:29:25 -0400
Message-ID: <4A2C69FD.2030800@redhat.com>
Date: Mon, 08 Jun 2009 09:31:41 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/39] kbuild/headers_check: refine extern check
References: <20090605233720.GA13588@uranus.ravnborg.org> <1244245377-17441-18-git-send-email-sam@ravnborg.org> <200906060046.07421.arnd@arndb.de> <20090606083844.GA14555@uranus.ravnborg.org>
In-Reply-To: <20090606083844.GA14555@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Sat, Jun 06, 2009 at 12:46:07AM +0000, Arnd Bergmann wrote:
>   
>> On Friday 05 June 2009 11:42:36 pm Sam Ravnborg wrote:
>>     
>>> From: Amerigo Wang <amwang@redhat.com>
>>>
>>> 'extern' checking information is not clear, refine it.
>>> Plus, fix a comment.
>>>
>>> Signed-off-by: WANG Cong <amwang@redhat.com>
>>> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
>>>       
>> I still think this is pointless and should just be removed
>> (or replaced with a patch to kill the apostrophe in there).
>>     
>
> So you wanted me to visit that link...
> I redid it like this:
>
> Subject: kbuild/headers_check: refine extern check
>
> 'extern' checking information is not clear, refine it.
> Plus, fix a comment.
>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> [sam: redid the extern error message]
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
>   

Yeah, after reading Arnd's comments, I agree on this patch.

Thanks, Sam!

> ---
> diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
> index 4414c43..db1dd7a 100644
> --- a/scripts/headers_check.pl
> +++ b/scripts/headers_check.pl
> @@ -2,7 +2,7 @@
>  #
>  # headers_check.pl execute a number of trivial consistency checks
>  #
> -# Usage: headers_check.pl dir [files...]
> +# Usage: headers_check.pl dir arch [files...]
>  # dir:   dir to look for included files
>  # arch:  architecture
>  # files: list of files to check
> @@ -37,7 +37,7 @@ foreach my $file (@files) {
>  		&check_include();
>  		&check_asm_types();
>  		&check_sizetypes();
> -		&check_prototypes();
> +		&check_declarations();
>  		# Dropped for now. Too much noise &check_config();
>  	}
>  	close FH;
> @@ -61,10 +61,12 @@ sub check_include
>  	}
>  }
>  
> -sub check_prototypes
> +sub check_declarations
>  {
> -	if ($line =~ m/^\s*extern\b/) {
> -		printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";
> +	if ($line =~m/^\s*extern\b/) {
> +		printf STDERR "$filename:$lineno: " .
> +		              "userspace cannot call function or variable " .
> +		              "defined in the kernel\n";
>  	}
>  }
>  
>   

