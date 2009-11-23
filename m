Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZKWOrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZKWOrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbZKWOrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:47:21 -0500
Received: from ukmta3.baesystems.com ([20.133.40.55]:6675 "EHLO
	ukmta3.baesystems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZKWOrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:47:20 -0500
X-IronPort-AV: E=Sophos;i="4.47,272,1257120000"; 
   d="scan'208";a="34480282"
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Kernel 2.6.27.7-9 for Suse 11.1 help required with CPU Clock freq/speed/ticks
Date: Mon, 23 Nov 2009 14:47:13 -0000
Message-ID: <FEBDE48FB0344846BAE4FB976A42642802BD9F28@GLKMS2101.GREENLNK.NET>
In-Reply-To: <FEBDE48FB0344846BAE4FB976A42642802BD9877@GLKMS2101.GREENLNK.NET>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Kernel 2.6.27.7-9 for Suse 11.1 help required with CPU Clock freq/speed/ticks
Thread-Index: AcppEi7wIIY+PkoxSNiMBwUwvkw6kwAAYeKQAC8e46AAnrV5QA==
References: <d0ced6d70911190416w3a354a50jcb0e93934805ca07@mail.gmail.com> <FEBDE48FB0344846BAE4FB976A42642802BA8271@GLKMS2101.GREENLNK.NET> <FEBDE48FB0344846BAE4FB976A42642802BD9877@GLKMS2101.GREENLNK.NET>
From: "Ahmed, Subhan (UK)" <Subhan.Ahmed@baesystems.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Nov 2009 14:47:10.0022 (UTC) FILETIME=[D5E28660:01CA6C4B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have requested response on below, I can hold on and wait if someone
can help on this but do let me know if this is not the right place to
ask such questions. Thanks for help.

Subhan

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Ahmed, Subhan
(UK)
Sent: 20 November 2009 10:58
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.27.7-9 for Suse 11.1 help required with CPU Clock
freq/speed/ticks


                    *** WARNING ***

  This message has originated outside your organisation,
  either from an external partner or the Global Internet. 
      Keep this in mind if you answer this message.


Hi All,

I know this is not email list for programming questions but it relates
to Kernel as well, in fact relying on kernel. Could someone please
through a light or guide me to the right direction.


Problem Statement:	High CPU clock speed/freq
Requirement:		Obtain a stable CPU clock ticks/speed/freq on
Suse 11.1 with kernel 2.6.27.7-9
Questions:			Please refer to the bottom of this page
Artifacts in Use:
-----------------------------------
OS:					Suse 11.1
GCC Version:		4.3.2 (Suse Linux) [gcc_4_3-brach revision
141291]
Kernel:				2.6.27.7-9
Kernel Mods:		
					* Un-check the Tickless option
					* Timer Frequency - 1000Hz
					* Preempt kernel

Others 1
-----------
OS:					Suse 10.2
GCC Version:		4.1.2 20061115 (prerelease)(SUSE Linux)
Kernel:				2.6.18.2-34-default
Kernel Mods:
					* Preemptible Kernel
(Low-Latency Desktop) (NEW)
					* Preempt The Big Kernel Lock
(NEW)
					* Timer frequency (NEW) - 1000
Hz (NEW)

Others 2
-----------
OS:					Suse 9.3
GCC Version:		3.3.5 20050117 (prerelease)(SUSE Linux)
Kernel				2.6.11.4-20a-default
Kernel Mods:		None

I executed the following c++ code on the above stated builds

CODE - file name test.cpp
#include <signal.h>
#include <sys/time.h>
#include <iostream>
#include <cstdlib>


using namespace std;

long long int counter = 0;
struct timeval last_time;
struct timeval curr_time;
double dif = 0.0;
double freq_sum = 0.0;
double reps = 0.0;
double freq_min = 99999.0;
double freq_max = 0.0;
long long int num_too_low = 0;

void time_check(int data)
{
    // work out the frequecy of the SIGALRMs
    ++counter;
    if (counter >= 1000)
    {

        // need to work out time since last 1000 ticks
	gettimeofday(&curr_time, NULL);
	dif = ((curr_time.tv_usec + curr_time.tv_sec * 1000000)
		- (last_time.tv_usec + last_time.tv_sec * 1000000));
        double freq = (counter / dif)  * 1000000;

        freq_sum = ((freq_sum * reps) + freq) / (reps + 1) ;

        ++reps;
        cout << "Frequency = " << freq << " reps= " << dif / 1000000 <<
endl;
        if (freq_min > freq) freq_min = freq;
        if (freq_max < freq) freq_max = freq;
        if (freq < 950) 
            ++num_too_low;
        last_time = curr_time;
        counter = 0;
    }
}

int main (int argc, char * argv[])
{
    cout << "go" /* << "\a \a \a" */ << endl;
	
    int res;
    gettimeofday(&last_time, NULL);
    struct sigaction action;

    struct itimerval timer_value;

    timer_value.it_value.tv_sec = 0;
    timer_value.it_value.tv_usec = 1;
    timer_value.it_interval.tv_sec = 0;
    timer_value.it_interval.tv_usec = 1;

    action.sa_handler = time_check;
    action.sa_flags = SA_NOMASK;
    sigemptyset(&action.sa_mask);

    sigaction( SIGALRM, &action, NULL);
    res = setitimer( ITIMER_REAL, &timer_value, NULL );
    if (res == -1)
        cout << "error in setitimer" << endl;

    cout << "Starting CPU Test program" << endl;
    // loop for a long time

    while (reps < 3000.0)
    {
        sleep(1);
    }
    cout << "average CPU frequency = " << freq_sum << endl;
    cout << "reps = " << reps << endl;
    cout << "Min = " << freq_min << "  Max = " << freq_max << endl;
    cout << "number of low = " << num_too_low << endl;
    return 0;
}

Compiled the above code with 	"g++ -o test test.cpp"
Run the above code with 		"./test"

Observations:
SUSE Version    AVG. Frequency        		AVG. REPS
Suse 9.3  		999.xxx to 990.xxx  			reps > 1
(on average)
Suse 10.2 		999.xxx to 998.xxx  			reps (1
- 1.001)
Suse 10.3     	1000.xxx to 912.xxx  			reps (1 - 1.090)
Suse 11.1       0 to  324263.xxx  				reps
(-2e-0.6 upto 0.005112)

Suse 11.1 - Options:

- Turn off ACPI in options when booting with clock=tsc | clock=pit

Observations for suse 11.1 with options acpi=off and clock=tsc |
clock=pit

SUSE Version    AVG. Frequency        		AVG. REPS
Suse 11.1 		710.xxx to 999.xxx      		reps
(1.37xx to 1.0002)

Hardware used for Suse 11.1 - HP Pavilion Slimline s3821uk Desktop PC
(NQ808AA) specifications - HP Home & Home Office products
http://h10010.www1.hp.com/wwpc/uk/en/ho/WF10a/12454-12454-3329740-64546-
64546-3884669.html?jumpid=in_r2515_uk/en/hho/ipg/psc404redirect-ot-xx-xx
-/chev/

While testing no other application/s were running.

Question:

* Is my c++ code correct?
* Am I using the correct way to get the clock ticks or is there more
reliable tchnique avaliable to do this?
* Is that a problem with new Kernel if so is it a known issue ?
* Do I need to modify the Kernel to obtain regular and stable clock tick
at 1000 Hz ?
* Do I have to upgrade the Kernel ?
* Would be great, if pointed to the right direction for solution (e.g.
another forum) if no solution at hand.

Thanks

Subhan

********************************************************************
This email and any attachments are confidential to the intended
recipient and may also be privileged. If you are not the intended
recipient please delete it from your system and notify the sender.
You should not copy it or use it for any purpose nor disclose or
distribute its contents to any other person.
********************************************************************

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in the body of a message to majordomo@vger.kernel.org More majordomo
info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

