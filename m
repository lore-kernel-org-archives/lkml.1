Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab0AOO3p (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729Ab0AOO3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:29:44 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:47594 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab0AOO3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:29:44 -0500
Message-ID: <4B507B73.6000404@s5r6.in-berlin.de>
Date: Fri, 15 Jan 2010 15:28:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 (changelog update only)] scripts/get_maintainer.pl:
 Add --sections, print entire matched subsystem
References: <1263408063.8011.116.camel@Joe-Laptop.home>	 <20100114151254.72b57501.akpm@linux-foundation.org> <1263519770.1903.49.camel@Joe-Laptop.home>
In-Reply-To: <1263519770.1903.49.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Sample output:
> 
> $ ./scripts/get_maintainer.pl --sections -f drivers/net/usb/smsc95xx.c
> USB SMSC95XX ETHERNET DRIVER
> M:Steve Glendinning <steve.glendinning@smsc.com>
> L:netdev@vger.kernel.org
> S:Supported
> F:drivers/net/usb/smsc95xx.*
> USB SUBSYSTEM
> M:Greg Kroah-Hartman <gregkh@suse.de>
> L:linux-usb@vger.kernel.org
> W:http://www.linux-usb.org
> T:quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
[...]

Should it be machine-readable, or only human-readable?
In the latter case, some whitespace could be nice, like:

$ ./scripts/get_maintainer.pl --sections -f drivers/net/usb/smsc95xx.c

USB SMSC95XX ETHERNET DRIVER
    M:Steve Glendinning <steve.glendinning@smsc.com>
    L:netdev@vger.kernel.org
    S:Supported
    F:drivers/net/usb/smsc95xx.*

USB SUBSYSTEM
    M:Greg Kroah-Hartman <gregkh@suse.de>
    L:linux-usb@vger.kernel.org
    W:http://www.linux-usb.org
    T:quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
[...]

For example,

> @@ -346,6 +358,21 @@ foreach my $file (@files) {
>  	}
>  	foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
>  	    add_categories($line);
> +	    if ($sections) {
> +		my $i;
> +		my $start = find_starting_index($line);
> +		my $end = find_ending_index($line);
> +		for ($i = $start; $i < $end; $i++) {
> +		    my $line = $typevalue[$i];
> +		    if ($line =~ /^[FX]:/) {		##Restore file patterns
> +			$line =~ s/([^\\])\.([^\*])/$1\?$2/g;
> +			$line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
> +			$line =~ s/\\\./\./g;       	##Convert \. to .
> +			$line =~ s/\.\*/\*/g;       	##Convert .* to *
> +		    }

		    if ($line =~ /^.:/)
			print("    ");
		    else
			print("\n");

> +		    print("$line\n");
> +		}
> +	    }
>  	}
>      }
>  

-- 
Stefan Richter
-=====-==-=- ---= -====
http://arcgraph.de/sr/
