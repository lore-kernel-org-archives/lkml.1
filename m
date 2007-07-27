Return-Path: <linux-kernel-owner+w=401wt.eu-S965059AbXG0PJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059AbXG0PJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933252AbXG0PJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:09:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54077 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760261AbXG0PJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:09:04 -0400
Date: Fri, 27 Jul 2007 16:08:54 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Fwd: PROBLEM: serial port receive buffers not being flushed properly
Message-ID: <20070727150854.GA25935@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please reply to the original poster.

----- Forwarded message from craigeger@comcast.net -----

From: craigeger@comcast.net
To: rmk+serial@arm.linux.org.uk
Subject: PROBLEM: serial port receive buffers not being flushed properly
Date: Fri, 27 Jul 2007 14:51:00 +0000

See attached .txt and .c files.
Use that information to fill in all fields of the bug report form, and
post it to the mailing list with a subject of "PROBLEM: <one line
summary from [1.]>" for easy identification by the developers.

[1.] PROBLEM: serial port receive buffers not being flushed properly
[2.] After calling tcflush() or ioctl() with the TCFLSH argument, an ioctl()
	with the FIONREAD argument reports 0 bytes available for reading.
	However, a subsequent select() and read() of the port returns data.
	This problem is seen in 2.6.21.1 and 2.6.20, but is not seen in
	version 2.6.17.14. Other versions have not been tested. 
[3.] keywords: serial buffer flush
[4.] Kernel version (from /proc/version): 2.6.21.1
[5.] Most recent kernel version which did not have the bug: 2.6.17.14 (others between 2.6.17.14 and 2.6.20 not checked)
[6.] No OOPs message applicable.
[7.] See attached source file com_buffer_test.c
[8.] Environment
[8.1.] Linux Pohaku 2.6.21.1 #1 PREEMPT Thu Jul 12 14:43:22 CDT 2007 i486 GNU/Linux
 
Gnu C                  3.3.5
Gnu make               3.80
binutils               2.15
util-linux             2.12p
mount                  2.12p
module-init-tools      3.2-pre1
e2fsprogs              1.37
pcmcia-cs              3.2.5
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Procps                 3.2.1
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.2.1
udev                   056
Modules Loaded         ipv6 e100 mii genrtc ext3 jbd ide_disk ide_generic ns87415 piix siimage sc1200 generic cy82c693 cs5530 sis5513 via82cxxx rz1000 slc90e66 cmd64x pdc202xx_old hpt34x opti621 trm290 amd74xx hpt366 serverworks atiixp aec62xx triflex alim15x3 pdc202xx_new cs5520 ide_core unix
[8.2.] Processor information (from /proc/cpuinfo):
	processor	: 0
	vendor_id	: AuthenticAMD
	cpu family	: 4
	model		: 9
	model name	: 486 DX/4-WB
	stepping	: 4
	fdiv_bug	: no
	hlt_bug		: no
	f00f_bug	: no
	coma_bug	: no
	fpu		: yes
	fpu_exception	: yes
	cpuid level	: 1
	wp		: yes
	flags		: fpu
	bogomips	: 49.40
	clflush size	: 32
[8.3.] Module information (from /proc/modules):
ipv6 234848 10 - Live 0xc4c44000
e100 31632 0 - Live 0xc4bbb000
mii 5152 1 e100, Live 0xc4b83000
genrtc 9420 0 - Live 0xc4b99000
ext3 120392 1 - Live 0xc4bdf000
jbd 55976 1 ext3, Live 0xc4bac000
ide_disk 15808 2 - Live 0xc4b94000
ide_generic 1152 0 [permanent], Live 0xc4b81000
ns87415 3956 0 [permanent], Live 0xc487d000
piix 9764 0 [permanent], Live 0xc4b8a000
siimage 10912 0 [permanent], Live 0xc4b86000
sc1200 5152 0 [permanent], Live 0xc487a000
generic 4744 0 [permanent], Live 0xc4872000
cy82c693 4292 0 [permanent], Live 0xc486f000
cs5530 5056 0 [permanent], Live 0xc4867000
sis5513 14568 0 [permanent], Live 0xc4875000
via82cxxx 8676 0 [permanent], Live 0xc486b000
rz1000 2560 0 [permanent], Live 0xc482b000
slc90e66 5344 0 [permanent], Live 0xc4864000
cmd64x 10012 0 [permanent], Live 0xc4837000
pdc202xx_old 9408 0 [permanent], Live 0xc4860000
hpt34x 4672 0 [permanent], Live 0xc4834000
opti621 4228 0 [permanent], Live 0xc4831000
trm290 3748 0 [permanent], Live 0xc4829000
amd74xx 13308 0 [permanent], Live 0xc485b000
hpt366 15808 0 [permanent], Live 0xc4856000
serverworks 8264 0 [permanent], Live 0xc482d000
atiixp 6064 0 [permanent], Live 0xc4826000
aec62xx 7200 0 [permanent], Live 0xc4812000
triflex 3584 0 [permanent], Live 0xc481d000
alim15x3 11276 0 [permanent], Live 0xc4822000
pdc202xx_new 7744 0 [permanent], Live 0xc480c000
cs5520 4448 0 [permanent], Live 0xc480f000
ide_core 103204 27 ide_disk,ide_generic,ns87415,piix,siimage,sc1200,generic,cy82c693,cs5530,sis5513,via82cxxx,rz1000,slc90e66,cmd64x,pdc202xx_old,hpt34x,opti621,trm290,amd74xx,hpt366,serverworks,atiixp,aec62xx,triflex,alim15x3,pdc202xx_new,cs5520, Live 0xc483b000
unix 25808 2 - Live 0xc4815000

[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
01f0-01f7 : ide0
02e8-02ef : serial
02f8-02ff : serial
03c0-03df : vesafb
03e8-03ef : serial
03f6-03f6 : ide0
03f8-03ff : serial
0cf8-0cff : PCI conf1
f900-f9ff : 0000:00:11.0
fd00-fd3f : 0000:00:10.0
  fd00-fd3f : e100

00000000-0009e3ff : System RAM
0009e400-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cffff : Video ROM
000f0000-000fffff : System ROM
00100000-03ffffff : System RAM
  00100000-0026df65 : Kernel code
  0026df66-00321b2f : Kernel data
c0000000-c0000fff : 0000:00:10.0
  c0000000-c0000fff : e100
c0020000-c003ffff : 0000:00:10.0
  c0020000-c003ffff : e100
c1000000-c1ffffff : 0000:00:11.0
  c1000000-c17effff : vesafb
c2000000-c2000fff : 0000:00:11.0
ff000000-ff01ffff : 0000:00:11.0
fff00000-ffffffff : reserved
[8.5.] PCI information ('lspci -vvv' as root)
[8.6.] SCSI information (from /proc/scsi/scsi)
[8.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
[X.] Other notes, patches, fixes, workarounds:
	After sending several kbytes to the com port, an ioctl() with FIONREAD
	reports 4095 bytes available under 2.6.20 and 2.6.21.1. However, it
	reports 4096 bytes available under 2.6.17.14, and flushing works as
	expected with this version. Please see the comments in the attached
	source code for more details on the problem.


Thank you

/***************************************************************************
* NAME:          com_buffer_test.c
*
* PURPOSE:       Used to debug/demonstrate an issue with the flushing of
*                of serial port buffers under Linux. It appears that
*                tcflush(), or alternatively, an ioctl() with the TCFLSH
*                argument only flushes 4095 bytes of buffered data at the
*                com port. See comments in the code for further details.
***************************************************************************/

#define COM1                "/dev/ttyS0"
#define COM2                "/dev/ttyS1"
#define COM3                "/dev/ttyS2"
#define COM4                "/dev/ttyS3"

#define COM_PORT            COM2
#define BAUD_RATE           B115200
#define DATA_BUF_SIZE       10000

#include    <stdio.h>           // printf, getchar
#include    <fcntl.h>           // open, fcntl
#include    <unistd.h>          // close, read
#include    <sys/ioctl.h>       // ioctl
#include    <termios.h>         // termios struct

int main( void )
{
    int configure_com( int fd );

    unsigned char data[DATA_BUF_SIZE]   = { 0 };
    int ret_val                         = 0;
    int cp_fd                           = 0;
    int byte_count                      = 0;
    int total_bytes                     = 0;
    struct timeval timeout;
    fd_set input;
    
    // Build the fd_set and set the timeout value used by select()
    FD_ZERO( &input );       // Clear the fd_set
    FD_SET( cp_fd, &input ); // The COM fd 

    timeout.tv_sec = 5;
    timeout.tv_usec = 0;
    
    // Open the com port device file.
    printf( "Opening device file.\n" );
    if( (cp_fd = open( COM_PORT, O_RDWR | O_NOCTTY | O_NONBLOCK )) == -1 )
    {
        printf( "Unable to open device file %s.\n", COM_PORT );
        return( cp_fd );
    } // if( (cp_fd = open( COM_PORT, O_RDWR | O_NOCTTY | O_NONBLOCK )) == -1 )

    // Setup the COM port.
    printf( "Configuring COM port.\n" );
    if( (ret_val = configure_com( cp_fd )) != 0 )
    {
        printf( "Failure configuring COM port.\n" );
        close( cp_fd );
        return( ret_val );
    } // if( (ret_val = configure_com( cp_fd )) != 0 )

    // Prompt the user to send data to the port. At this point, use another program
    // to send more than 4095 bytes of data to our com port. I typically send 100kb
    // or so.
    printf( "\n\nSend (a lot of) data now. When the send is complete, hit 'Enter'.\n" );
    while( (ret_val = getchar()) != '\n' );
    
    // Now, we're going to "flush" the com port buffer, and then query it for
    // the number of bytes available for reading after we flush it. In previous
    // tests, the 2nd query has reported 0 bytes available. However, a subsequent
    // read (even though we've stopped sending data) will return more data! It
    // should also be noted that a delay after the flush and before the 2nd query
    // will report more data available. It appears that a maximum of 4095 bytes
    // can be flushed per ioctl call.
    printf( "About to flush the buffer.\n" );
    
    if( (ret_val = ioctl( cp_fd, FIONREAD, &byte_count )) != 0 ) // Get number of bytes available.
    {
        printf( "Failure calling ioctl with FIONREAD argument.\n" );
        close( cp_fd );
        return( ret_val );
    } // if( (ret_val = ioctl( cp_fd, FIONREAD, &byte_count )) != 0 )

    while( byte_count > 0 )
    {
        // Note that this is 4095 bytes with versions 2.6.21.1 and 2.6.20,
        // but is 4096 bytes with version 2.6.17.14. Not sure if this is
        // related to the flush issue, but seemed worth noting.
        printf( "Bytes available before flush: %i\n", byte_count );
        ioctl( cp_fd, TCFLSH, TCIFLUSH );
        if( (ret_val = ioctl( cp_fd, TCFLSH, TCIFLUSH )) != 0 ) // Perform flush.
        {
            printf( "Failure calling ioctl with TCFLSH argument.\n" );
            close( cp_fd );
            return( ret_val );
        } // if( (ret_val = ioctl( cp_fd, TCFLSH, TCIFLUSH )) != 0 )

        // If we sleep for a bit here, the results of the next query will
        // be > 0. If we don't sleep, the results will be 0.
        
        //usleep( 100000 );
        
        if( (ret_val = ioctl( cp_fd, FIONREAD, &byte_count )) != 0 ) // Get number of bytes available.
        {
            printf( "Failure calling ioctl with FIONREAD argument.\n" );
            close( cp_fd );
            return( ret_val );
        } // if( (ret_val = ioctl( cp_fd, FIONREAD, &byte_count )) != 0 )
        printf( "Bytes available after flush: %i\n", byte_count );
    }

    printf( "Calling select(). Since we've already flushed the buffer, there\n" );
    printf( "should be NO MORE DATA available at the port!\n\n" );
    printf( "If nothing is available, select() will timeout after 5 seconds.\n" ); 

    // Build the fd set.
    FD_ZERO( &input );       // Clear the fd_set
    FD_SET( cp_fd, &input ); // The COM fd
        
    // Wait for up to 5 seconds for input with select. We would expect this to just
    // timeout, because there should be no more data available.
    if( (ret_val = select( cp_fd + 1, &input, NULL, NULL, &timeout )) < 0 )
    {
        printf( "Error on select().\n" );
        close( cp_fd );
        return( ret_val );
    } // if( (ret_val = select( cp_fd + 1, &input, NULL, NULL, NULL )) < 0 )

    else if( ret_val == 0 ) // Timeout. This is what should happen.
    {
        printf( "select() timed out. Nothing available at the port.\n" );
    } // else if( ret_val == 0 )
     
    // Data at the com port! Shouldn't be there, as we've "flushed" the buffer!
    // Note also that even though we're asking to read up to 10000 bytes per
    // read call, we can apparently only read 4095 bytes at a time.
    else if( FD_ISSET( cp_fd, &input ) )
    {
        printf( "select() triggered for COM port.\n" );
        printf( "This data should have been flushed already!\n" );
        ioctl( cp_fd, FIONREAD, &byte_count );
        printf( "Bytes available at port: %i\n", byte_count );
        while( (byte_count = read( cp_fd, data, DATA_BUF_SIZE )) > 0 )
        {
            printf( "Read %i bytes at COM port.\n", byte_count );
            total_bytes += byte_count;
        }
        printf( "Read %i bytes, AFTER flushing the buffer.\n", total_bytes );
    } // else if( FD_ISSET( cp_fd, &input ) )

    // Close device file.
    close( cp_fd );
    
    return( 0 );
} // int main( void )




/////////////////////////////////////////////////////////////////////////////
// configure_com()
// Takes a file descriptor for the COM port and configures it appropriately.
// Flushes the COM port buffer before returning. Returns 0 on
// success. If an error occurs, returns -1.
/////////////////////////////////////////////////////////////////////////////
int configure_com( int fd )
{
    struct termios options;
    int ret_val     = 0;
    
    // Get attributes.
    if( (ret_val = tcgetattr( fd, &options )) == -1 )
    {
        printf( "configure_com: Unable to obtain COM port attributes.\n" );
        return( ret_val );
    } // if( (ret_val = tcgetattr( fd, &options )) == -1 )

    // Set input baud rate.
    if( (ret_val = cfsetispeed( &options, BAUD_RATE )) == -1 )
    {
        printf( "configure_com: Unable to set COM port input baud rate.\n" );
        return( ret_val );
    } // if( (ret_val = cfsetispeed( &options, BAUD_RATE )) == -1 )

    // Set output baud rate.
    if( (ret_val = cfsetospeed( &options, BAUD_RATE )) == -1 )
    {
        printf( "configure_com: Unable to set COM port output baud rate.\n" );
        return( ret_val );
    } // if( (ret_val = cfsetospeed( &options, BAUD_RATE )) == -1 )

    // Set up for 8N1, 8 data bits, no parity, 1 stop bit. Disable hardware flow
    // control. Ignore control signals, and enable the port for reading.
    options.c_cflag &= ~(PARENB | CSTOPB | CSIZE | CRTSCTS);
    options.c_cflag |= (CS8 | CLOCAL | CREAD);

    // Set up for raw (non-canonical) input, disable echoing and signalling.
    options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
    // Disable software flow control
    options.c_iflag &= ~(IXON | IXOFF | IXANY);

    // Set up for raw output.
    options.c_oflag &= ~OPOST;

    // Set the updated attributes, flushing the port first.
    if( (ret_val = tcsetattr( fd, TCSAFLUSH, &options )) == -1 )
    {
        printf( "configure_com: Unable to set COM port attributes.\n" );
        return( ret_val );
    } // if( (ret_val = tcsetattr( fd, TCSAFLUSH, &options )) == -1 )
        
    // Ensure we're setup for non-blocking operations. If open was used
    // with O_NONBLOCK or O_NDELAY, this will be the case anyway. This fcntl
    // call will make sure of this.
    if( (ret_val = fcntl( fd, F_SETFL, FNDELAY )) == -1 )
    {
        printf( "configure_com: Unable to configure COM port for non-blocking operations.\n" );
        return( ret_val );
    } // if( (ret_val = fcntl( fd, F_SETFL, FNDELAY )) == -1 )
    
    return( ret_val );
} // static int configure_com( int cp_fd )


----- End forwarded message -----

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
