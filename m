Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZKHWrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZKHWrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 17:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbZKHWri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 17:47:38 -0500
Received: from lucidpixels.com ([75.144.35.66]:54577 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558AbZKHWri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 17:47:38 -0500
Date: Sun, 8 Nov 2009 17:47:43 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, news@phoronix.com
cc: Alan Piszcz <ap@solarrain.com>
Subject: Intel DP55KG + Intel Core i7 870 + Phoronix Benchmarks / Turbo
 Boost
Message-ID: <alpine.DEB.2.00.0911081638400.25174@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I performed a bunch of tests with my processor to see if Turbo Boost was
working correct, the short answer is, it /appears/ to be..

CPU Tested: i870
Distribution: PTS Live CD 2009.3 x86_64
Distribution: Debian Testing x86_64

Intel's Benchmarks: (with a correctly working BIOS)
http://www.phoronix.com/scan.php?page=article&item=intel_lynnfield_add&num=4

Phoronix's Benchmarks: (when Turbo Boost is not working correctly)
http://www.phoronix.com/scan.php?page=article&item=intel_lynnfield&num=5

Note on PostgreSQL: This is disk-bound, so do not compare CD vs. NON-CD.

  Phoronix Benchmark for Apache 2.2.11 (i870):  7422.11 static web page serving
     Intel Benchmark for Apache 2.2.11 (i750):  8497.47 static web page serving
  Same test my host (Phoronix Live CD) (i870): 10789.11 static web page serving*

             Phoronix Benchmark for LAME 3.98.2 (i870):  46.01 seconds
                Intel Benchmark for LAME 3.98.2 (i750):  26.18 seconds
           Same test my host (Phoronix Live CD) (i870):  23.47 seconds*

    Phoronix Benchmark for GraphicsMagick 1.3.6 (i870):   89.66 iterations
       Intel Benchmark for GraphicsMagick 1.3.6 (i750):  124.66 iterations
           Same test my host (Phoronix Live CD) (i870):  184.00 iterations*

    Phoronix Benchmark for PostgreSQL 8.4.0 (i870):  540.87 transactions
       Intel Benchmark for PostgreSQL 8.4.0 (i750): 1965.70 transactions
-
       Same test my host (Phoronix Live CD) (i870): 7208.42 transactions*

--

w/no CPU_FREQ in kernel, running Phoronix test suite (pkg) on Debian/Testing
Kernel 2.6.31.4 x86_64 [keep in mind Phoronix Live CD runs on ramdisk], so
my main points of comparison will be [NO ACPI_FREQ vs. ACPI_FREQ]

       Phoronix Benchmark for Apache 2.2.11 (i870): 7422.11 static web page
          Intel Benchmark for Apache 2.2.11 (i750): 8497.47 static web page
       Same test my host (Phoronix Live CD) (i870): 10789.11 static web page
  Same test my host (Debian w/NO ACPI_FREQ) (i870): 12026.90 static web page*
     Same test my host (Debian w/ACPI_FREQ) (i870): 11883.58 static web page-

          Phoronix Benchmark for LAME 3.98.2 (i870):  46.01 seconds
             Intel Benchmark for LAME 3.98.2 (i750):  26.18 seconds
        Same test my host (Phoronix Live CD) (i870):  23.47 seconds*
   Same test my host (Debian w/NO ACPI_FREQ) (i870):  29.82 seconds-
      Same test my host (Debian w/ACPI_FREQ) (i870):  26.36 seconds+

    Phoronix Benchmark for GraphicsMagick 1.3.6 (i870):   89.66 iterations
       Intel Benchmark for GraphicsMagick 1.3.6 (i750):  124.66 iterations
           Same test my host (Phoronix Live CD) (i870):  184.00 iterations*
      Same test my host (Debian w/NO ACPI_FREQ) (i870):  152.33 iterations-
         Same test my host (Debian w/ACPI_FREQ) (i870):  165.66 iterations+

    Phoronix Benchmark for PostgreSQL 8.4.0 (i870):  540.87 transactions
       Intel Benchmark for PostgreSQL 8.4.0 (i750): 1965.70 transactions
       Same test my host (Phoronix Live CD) (i870): 7208.42 transactions*
-
  Same test my host (Debian w/NO ACPI_FREQ) (i870): 1446.41 transactions+
     Same test my host (Debian w/ACPI_FREQ) (i870): 1417.55 transactions-

--

>From my bzip2 test:

Phoronix Live CD:
ptslive@Gernlinden:~$ ./run_test.sh
39.81user 0.10system 0:39.91elapsed 100%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+2025minor)pagefaults 0swaps

My host:
50.14user 0.11system 0:50.27elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+2653minor)pagefaults 0swaps

10 seconds faster! Question is-- is Ubuntu's distribution that much faster?
Or is it just the way the kernel is configured?

--

ok, so is it the Live CD / Distribution itself that lends itself to the speed
or is it the kernel configuration?  took the config-2.6.31-3 from the Live CD's
/boot and used that as my kernel base as a test:

--

First, a quick test: (bzip2 -9 2.6.31 kernel tarball)

bzip2 test Debian vs. Ubuntu, same kernel configuration (minus 2.6.31 vs.
2.6.31.4)

My host (w/phoronix kernel configuration)

Almost 10 seconds faster:
40.97user 0.09system 0:41.07elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
64inputs+0outputs (1major+2021minor)pagefaults 0swaps

.. interesting .. hopefully the rest of the benchmarks (4) will reflect faster
.. speeds as well ..

--

My kernel .config vs. Phoronix's Distribution's .config: (yes I realize
glibc/etc/libraries could be all different versions, etc-- but I want to see
if this makes a difference), e.g. the Phoronix kernel uses NO_HZ, 250hz, much
different than my configuration... And also, Phoronix's kernel is 2.6.31, th
one I am using is 2.6.31.4.

             Intel Benchmark for Apache 2.2.11 (i750):  8497.47 static web page
          Same test my host (Phoronix Live CD) (i870): 10789.11 static web page
        Same test my host (Debian w/ACPI_FREQ) (i870): 11883.58 static web page
     Same test my host (Debian w/PHORONIX_CFG) (i870):  9343.15 static web page

- slower here, is this due to 250hz vs 1000hz setting (?)

               Intel Benchmark for LAME 3.98.2 (i750):    26.18 seconds
          Same test my host (Phoronix Live CD) (i870):    23.47 seconds*
        Same test my host (Debian w/ACPI_FREQ) (i870):    26.36 seconds+
     Same test my host (Debian w/PHORONIX_CFG) (i870):    24.24 seconds-

      Intel Benchmark for GraphicsMagick 1.3.6 (i750):  124.66 iterations
          Same test my host (Phoronix Live CD) (i870):  184.00 iterations*
        Same test my host (Debian w/ACPI_FREQ) (i870):  165.66 iterations-
     Same test my host (Debian w/PHORONIX_CFG) (i870):  173.66 iterations+

          Intel Benchmark for PostgreSQL 8.4.0 (i750):  1965.70 transactions
          Same test my host (Phoronix Live CD) (i870):  7208.42 transactions*
-
        Same test my host (Debian w/ACPI_FREQ) (i870):  1417.55 transactions
     Same test my host (Debian w/PHORONIX_CFG) (i870):  1466.55 transactions

--

Phoronix kernel config from live CD:
http://home.comcast.net/~jpiszcz/20091108/config-2.6.31-3-generic.phoronix.txt

My kernel config:
http://home.comcast.net/~jpiszcz/20091108/config-2.6.31.4.txt

Conclusion: Using the +ACPI_FREQ option yields some advantage; however,
it does make the CPU/motherboard emit a very high pitch noise when the
system is not doing anything.  The phoronix kernel config with +ACPI_FREQ 
enabled and the kernel options they set yield better performance 
than my kernel configuration.  The next question is which options (outside 
of ACPI_FREQ) yield the +10 seconds faster speed with bzip2 (along with 
the other 3 benchmarks outside of Apache, which was slower).

Just modified my kernel configuration:

My regular kernel configuration (does not have NO_HZ or ACPI_FREQ)
50.14user 0.11system 0:50.27elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+2653minor)pagefaults 0swaps

ACPI_FREQ+NO_HZ+100 HZ
40.93user 0.15system 0:41.17elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+2020minor)pagefaults 0swaps

ACPI_FREQ+NO_HZ+250 HZ
41.04user 0.14system 0:41.24elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+2021minor)pagefaults 0swaps

ACPI_FREQ+NO_HZ+300 HZ
40.89user 0.11system 0:41.11elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+2023minor)pagefaults 0swaps

ACPI_FREQ+NO_HZ+1000 HZ
41.62user 0.10system 0:41.80elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+2021minor)pagefaults 0swaps

ACPI_FREQ+1000 HZ (but disable NO_HZ) - almost back to ~50 seconds again
44.58user 0.15system 0:44.77elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+2022minor)pagefaults 0swaps

NO_HZ+1000 HZ (but disable ACPI_FREQ) - back to ~50 seconds
50.00user 0.10system 0:50.16elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+2020minor)pagefaults 0swaps

So NO_HZ accompanied by ACPI_FREQ speeds up the bzip2 by ~10 seconds (below):
41.20user 0.11system 0:41.37elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+2022minor)pagefaults 0swaps

More tests are needed but I was solely interested in single-core 
performance to take advantage of turbo boost.  Comparing the results on 
the phoronix live CD with those from Intel when they benchmarked the i750, 
they seem to be in-line with what one would expect (overall)..

Justin.
