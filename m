Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbXJKP6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbXJKP6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbXJKP6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:58:24 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37605 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbXJKP6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:58:23 -0400
Date: Thu, 11 Oct 2007 11:57:56 -0400
From: "Mike D. Day" <ncmike@us.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: fix minor problems in checkpatch.pl-next
Message-ID: <20071011155756.GA18901@silverwood.ncultra.org>
Reply-To: ncmike@us.ibm.com
References: <20071011122800.GA10216@silverwood.ncultra.org> <20071011143216.GD3376@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20071011143216.GD3376@shadowen.org>
X-PGP-Key: http://www.ncultra.org/ncmike/pubkey.asc
X-PGP-Fingerprint: A2EE D0E6 21B7 0DEC 29B5  D5FD 3B27 3154 452B 7C21
x-gpg-key: http://www.ncultra.org/ncmike/pubkey.asc
x-gpg-fingerprint: A2EE D0E6 21B7 0DEC 29B5  D5FD 3B27 3154 452B 7C21
Organization: IBM Linux Technology Center
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/07 15:32 +0100, Andy Whitcroft wrote:
>On Thu, Oct 11, 2007 at 08:28:00AM -0400, Mike D. Day wrote:
>> When forming the prefix to output error msgs in gnu gcc format, the
>> lack of a type ($ or @) when referencing ARGV causes error messages.
>> 
>> When invoked to check source files, the linenumber was off by +3 in
>> the gcc format output.
>> 
>> Signed-off-by: Mike D. Day <ncmike@ncultra.org>
>> 
>> --- checkpatch.pl-next	2007-10-11 07:28:41.000000000 -0400
>> +++ /home/mdday/bin/checkpatch	2007-10-11 08:16:07.000000000 -0400
>> @@ -452,7 +452,6 @@
>> 
>> 		my $rawline = $line;
>> 
>> -		$prefix = "ARGV:$linenr: " if ($emacs);
>> 
>> #extract the filename as it passes
>> 		if ($line=~/^\+\+\+\s+(\S+)/) {
>> @@ -517,6 +516,9 @@
>> 		my $herecurr = "$here\n$line\n";
>> 		my $hereprev = "$here\n$prevline\n$line\n";
>> 
>> +		$prefix = "@ARGV:$realline: " if ($emacs && $file);
>> +		$prefix = "@ARGV:$linenr: " if ($emacs && !$file);
>> +
>> #check the patch for a signoff:
>> 		if ($line =~ /^\s*signed-off-by:/i) {
>> 			# This is a signoff, if ugly, so do not double 
>> 			report.
>
>Hmmm, dunno how this one ever was visible?  Some error on my part.  That
>line now shows $filename rather than ARGV.  
>
>I see you have different line numbers depending on whether this is a
>file or diff.  Would you ever pass in a plain diff in emacs mode, and
>what would the line number mean.

Here is the message in my compile window as it is displayed by -next:

ARGV:148: ERROR: need a space before the open parenthesis '('
#148: FILE: home/mdday/src/slp-devel/src/cmd-utils/lslp-linux.c:145:
+  if(dieNow)

The filename is reported as ARGV and the line number is reported as
148. These should be FILE: #line:FILE: \basename\filename:line: 

Also, the line number is reported differently. The correct line number
is reported at the end of the second line.

I tested these patches with both sources and patches, from bash and from emacs and they seem to work ok.


Mike



>
>-apw
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Mike D. Day
IBM LTC
Cell: 919 412-3900
Sametime: ncmike@us.ibm.com AIM: ncmikeday  Yahoo: ultra.runner
PGP key: http://www.ncultra.org/ncmike/pubkey.asc
