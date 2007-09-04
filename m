Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbXIDQxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbXIDQxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 12:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbXIDQxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 12:53:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:45892 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbXIDQxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 12:53:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EnYTA0EgsvJzEHGrU2JhBCXXYoEI6+X+kR/e1dXbNiKfTt+N/wBIKwEBPxZdHhwat2/MgsFuedUl77juT/Z17kehDaziSd+72iYKKLvmp0B4I+xwA0SpACTsFd5wwF2N4O2Bi6Rtpthi/NZ1sM+SPMEYg8QksptQ0uiegP0vA4Q=
Message-ID: <89a10cbc0709040953i58f64a9cx957d69dd35519083@mail.gmail.com>
Date: Tue, 4 Sep 2007 13:53:03 -0300
From: "Guilherme Vilela" <vilela.list@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Problem to recognize that the file system is full
In-Reply-To: <89a10cbc0709040951u1786e7e3g76708bfcb7117f44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <89a10cbc0709040951u1786e7e3g76708bfcb7117f44@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm tryng to mount a nfs file system with the option async and run a
program that writes to the file system. The problem is that the
program keep writing even when the file system is full. It appears
that the nfs dont see that the file system is full and keeps writing
to the cache. This program does'nt occur when mounting with the sync
option or with async and noac option, but the performance get very
poor and that is important to my application. The problem doesnt occur
too with the local file system. I'm running linux centos 5.0.

Below is my test program.
Any idea how to resolve this problem?

Thanks,
Guilherme


//io-stress.cpp

#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main()
{
        int i = 0;
        string roller( "|/-\\" );
        string sample( "*", 1024 );
        ofstream ofs( "io-stress.txt" );
        ofs.exceptions( ios::failbit | ios::badbit );

        while ( ofs )
        {
                ofs << sample << endl << flush;
                ofs.flush();
                if ( i == 3 )
                        i = 0;
                cout << "\b" << roller[i++];
        }
        ofs.close();
        return 0;
}
